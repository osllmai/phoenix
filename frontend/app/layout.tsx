import './globals.css';

import ThemeApplier from './components/ThemeApplier';
import Providers from './providers';

export const metadata = {
  title: 'Phoenix',
  description: 'Local LLM — web surface',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <ThemeApplier />
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
