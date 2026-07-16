"""Phoenix backend load/pressure test. Host comes from --host / LOCUST_HOST."""
from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from locust import HttpUser, between, events  # noqa: E402

import seed  # noqa: E402
import tasks_auth as auth  # noqa: E402
import tasks_jobs as jobs  # noqa: E402
import tasks_read as read  # noqa: E402
import tasks_write as write  # noqa: E402


@events.test_start.add_listener
def _seed_pools(environment, **kwargs):
    seed.seed(environment.host)


class BrowseUser(HttpUser):
    weight = 8
    wait_time = between(0.5, 2.0)
    tasks = {
        read.health: 3,
        read.list_fleet_runs: 5,
        read.get_fleet_run: 5,
        read.list_extensions: 6,
        read.search_extensions: 3,
        read.get_extension: 4,
        read.list_documents: 5,
        read.get_document: 4,
        read.list_searches: 3,
        read.get_search: 3,
        read.poll_job: 4,
    }


class WriteUser(HttpUser):
    weight = 2
    wait_time = between(1.0, 3.0)
    tasks = {
        write.create_fleet_run: 3,
        write.install_extension: 4,
        write.uninstall_extension: 1,
        jobs.start_deepsearch: 2,
        jobs.start_ai_chat_deep_search: 2,
        jobs.create_document: 3,
        jobs.create_and_delete_document: 1,
        read.list_fleet_runs: 4,
        read.list_documents: 3,
    }


class MergeStormUser(HttpUser):
    weight = 1
    wait_time = between(0.1, 0.5)
    tasks = {write.merge_winner: 1}


if os.getenv('PHOENIX_SESSION_TOKEN'):

    class AccountsUser(HttpUser):
        weight = 1
        wait_time = between(1.0, 3.0)
        tasks = auth.TASKS

        def on_start(self):
            self.client.headers['X-Session-Token'] = os.environ['PHOENIX_SESSION_TOKEN']
