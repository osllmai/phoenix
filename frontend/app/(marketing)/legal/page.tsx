import type { Metadata } from 'next';
import Link from 'next/link';

import s from './page.module.css';

export const metadata: Metadata = {
  title: 'Legal — Phoenix',
  description: 'Company information and legal notices for Phoenix, operated by NEMATI AI LLC.',
};

const COMPANY = [
  ['Legal name', 'NEMATI AI LLC'],
  ['Entity type', 'Domestic Limited Liability Company'],
  ['Jurisdiction', 'Wisconsin, United States'],
  ['Entity ID', 'D075329'],
  ['Effective date', 'February 15, 2023'],
  ['Status', 'Good Standing'],
] as const;

export default function LegalPage() {
  return (
    <main className={s.page}>
      <div className={s.wrap}>
        <p className={s.eyebrow}>Legal</p>
        <h1 className={s.title}>Company information</h1>
        <p className={s.lede}>
          Phoenix is developed and operated by NEMATI AI LLC. The details below reflect
          the company&rsquo;s registration on public record.
        </p>

        <section className={s.card}>
          <h2 className={s.cardTitle}>Company</h2>
          <dl className={s.rows}>
            {COMPANY.map(([k, v]) => (
              <div className={s.row} key={k}>
                <dt className={s.k}>{k}</dt>
                <dd className={s.v}>{v}</dd>
              </div>
            ))}
          </dl>
        </section>

        <div className={s.split}>
          <section className={s.card}>
            <h2 className={s.cardTitle}>Registered office</h2>
            <address className={s.addr}>
              NEMATI AI LLC<br />
              7343 N Teutonia Ave, Apt 7<br />
              Milwaukee, WI 53209-2051<br />
              United States
            </address>
          </section>

          <section className={s.card}>
            <h2 className={s.cardTitle}>Registered agent</h2>
            <address className={s.addr}>
              Ali Nemati<br />
              7343 N Teutonia Ave, Apt 7<br />
              Milwaukee, WI 53209-2051<br />
              United States
            </address>
          </section>
        </div>

        <section className={s.card}>
          <h2 className={s.cardTitle}>License &amp; copyright</h2>
          <p className={s.body}>
            Phoenix is free software licensed under the GNU Affero General Public License v3.0.
            Copyright &copy; 2023&ndash;2026 NEMATI AI LLC. All product names and marks are the
            property of their respective owners.
          </p>
        </section>

        <p className={s.back}>
          <Link href="/landing">&larr; Back to Phoenix</Link>
        </p>
      </div>
    </main>
  );
}
