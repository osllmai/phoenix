'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

import { api } from './api';

export function useModels() {
  return useQuery({ queryKey: ['models'], queryFn: api.list });
}

export function useModelMutations() {
  const qc = useQueryClient();
  const onSuccess = () => qc.invalidateQueries({ queryKey: ['models'] });
  return {
    add: useMutation({
      mutationFn: (v: { name: string; path: string }) => api.add(v.name, v.path),
      onSuccess,
    }),
    select: useMutation({ mutationFn: (id: number) => api.select(id), onSuccess }),
    like: useMutation({
      mutationFn: (v: { id: number; liked: boolean }) => api.like(v.id, v.liked),
      onSuccess,
    }),
    remove: useMutation({ mutationFn: (id: number) => api.remove(id), onSuccess }),
  };
}
