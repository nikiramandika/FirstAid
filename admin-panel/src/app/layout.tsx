import './globals.css';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-slate-50 text-slate-800">
        <div className="max-w-6xl mx-auto p-6">
          <header className="mb-6 flex items-center justify-between">
            <h1 className="text-2xl font-semibold tracking-tight">FirstAid Admin</h1>
            <nav className="text-sm text-slate-500">Manage content</nav>
          </header>
          {children}
        </div>
      </body>
    </html>
  );
} 