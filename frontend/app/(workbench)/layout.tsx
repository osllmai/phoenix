import MobileNav from '@/app/components/MobileNav';
import Sidebar from '@/app/components/Sidebar';

export default function WorkbenchLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="app">
      <div className="deskNav">
        <Sidebar />
      </div>
      <MobileNav />
      <div className="main">{children}</div>
    </div>
  );
}
