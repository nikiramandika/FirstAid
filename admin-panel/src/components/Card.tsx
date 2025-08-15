export default function Card({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return (
    <div className={`bg-white rounded-xl shadow-sm ring-1 ring-slate-200 ${className}`}>
      {children}
    </div>
  );
} 