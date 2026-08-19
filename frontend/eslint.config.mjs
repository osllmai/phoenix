import { dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

import { FlatCompat } from '@eslint/eslintrc'

const compat = new FlatCompat({ baseDirectory: dirname(fileURLToPath(import.meta.url)) })

const config = [
  { ignores: ['.next/**', 'node_modules/**', 'next-env.d.ts', 'test-results/**', 'e2e/.scenario-shots/**'] },
  ...compat.extends('next/core-web-vitals', 'next/typescript'),
]

export default config
