"use client";
import Link from 'next/link';
import Card from '@/components/Card';
import { supabase } from '@/lib/supabaseClient';
import { useEffect, useState } from 'react';

export default function CategoriesPage() {
  const [rows, setRows] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('name', { ascending: true });
      if (error) setError(error.message);
      setRows(data ?? []);
      setLoading(false);
    })();
  }, []);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-semibold">Categories</h2>
        <Link href="/categories/new" className="px-3 py-2 rounded-lg bg-blue-600 text-white">+ New Category</Link>
      </div>
      <Card>
        <div className="p-2">
          {loading && <p className="text-sm text-slate-500">Loading...</p>}
          {error && <p className="text-sm text-red-600">{error}</p>}
        </div>
        <table className="min-w-full text-sm">
          <thead>
            <tr className="text-left text-slate-500">
              <th className="py-3 px-4">Name</th>
              <th className="py-3 px-4">Color</th>
              <th className="py-3 px-4">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r: any, idx: number) => (
              <tr key={r.id} className={idx % 2 ? 'bg-slate-50' : ''}>
                <td className="py-3 px-4 font-medium">{r.name}</td>
                <td className="py-3 px-4">{r.color || '-'}</td>
                <td className="py-3 px-4">
                  <Link href={`/categories/edit/${r.id}`} className="text-blue-600 hover:underline">Edit</Link>
                </td>
              </tr>
            ))}
            {!loading && rows.length === 0 && (
              <tr>
                <td colSpan={3} className="py-6 px-4 text-center text-slate-500">No categories yet</td>
              </tr>
            )}
          </tbody>
        </table>
      </Card>
    </div>
  );
} 