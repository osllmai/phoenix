export const metadata = {
  title: 'Phoenix',
  description: 'Local LLM — web surface',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
