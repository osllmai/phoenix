import Sidebar from '@/app/components/Sidebar';

export default function WorkbenchLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="app">
      <Sidebar />
      <div className="main">{children}</div>
    </div>
  );
}
