"""Response-contract helpers: a 200 with a wrong body is a FAILURE, not a pass."""
from __future__ import annotations

from contextlib import contextmanager

from locust.exception import RescheduleTask, StopUser

NUM = (int, float)


class ContractError(AssertionError):
    pass


def _name(want) -> str:
    if isinstance(want, tuple):
        return '|'.join(t.__name__ for t in want)
    return want.__name__


def expect_object(body, spec: dict, where: str = 'body') -> dict:
    if not isinstance(body, dict):
        raise ContractError(f'{where}: expected an object, got {type(body).__name__}')
    for key, want in spec.items():
        if key not in body:
            raise ContractError(f'{where}: missing key {key!r} (got {sorted(body)})')
        value = body[key]
        wrong_bool = want is not bool and isinstance(value, bool)
        if wrong_bool or not isinstance(value, want):
            raise ContractError(
                f'{where}.{key}: expected {_name(want)}, got {type(value).__name__} ({value!r})'
            )
    return body


def expect_list(body, spec: dict, where: str = 'body', sample: int | None = 3) -> list:
    if not isinstance(body, list):
        raise ContractError(f'{where}: expected an array, got {type(body).__name__}')
    items = body if sample is None else body[:sample]
    for i, item in enumerate(items):
        expect_object(item, spec, f'{where}[{i}]')
    return body


SKIP = object()


def _parse(response, status: int):
    if response.status_code != status:
        text = (response.text or '')[:160]
        return SKIP, f'expected HTTP {status}, got {response.status_code}: {text}'
    try:
        return response.json(), None
    except ValueError:
        return SKIP, f'body is not JSON: {(response.text or "")[:160]!r}'


@contextmanager
def contract(response, status: int = 200):
    """Yield the parsed body; any raise inside the block lands in Locust's failure stats."""
    body, problem = _parse(response, status)
    if problem:
        response.failure(problem)
        try:
            yield body
        except (StopUser, RescheduleTask):
            raise
        except Exception:
            pass
        return
    try:
        yield body
    except (StopUser, RescheduleTask):
        raise
    except Exception as exc:
        response.failure(f'{type(exc).__name__}: {exc}')
    else:
        response.success()
