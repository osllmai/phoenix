export type Model = {
  id: number;
  name: string;
  path: string | null;
  installed: boolean;
  liked: boolean;
  addedAt: string | null;
};

export type ModelsResponse = { active: Model | null; data: Model[] };

function apiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE_URL;
  if (!base) throw new Error('NEXT_PUBLIC_API_BASE_URL is required');
  return base;
}

async function req<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`${apiBase()}${path}`, {
    headers: { 'content-type': 'application/json' },
    ...init,
  });
  if (!res.ok) {
    const body = (await res.json().catch(() => ({}))) as { error?: string };
    throw new Error(body.error ?? `HTTP ${res.status}`);
  }
  return res.json() as Promise<T>;
}

export const api = {
  list: () => req<ModelsResponse>('/v1/models'),
  add: (name: string, path: string) =>
    req<Model>('/v1/models', { method: 'POST', body: JSON.stringify({ name, path }) }),
  select: (id: number) =>
    req<{ active: Model }>(`/v1/models/${id}/select`, { method: 'POST' }),
  like: (id: number, liked: boolean) =>
    req(`/v1/models/${id}/like`, { method: 'POST', body: JSON.stringify({ liked }) }),
  remove: (id: number) => req(`/v1/models/${id}`, { method: 'DELETE' }),
};
