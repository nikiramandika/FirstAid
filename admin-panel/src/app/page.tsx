"use client";
import Link from 'next/link';
import { supabase } from '@/lib/supabaseClient';
import Card from '@/components/Card';
import { useEffect, useState } from 'react';

export default function Page() {
  const [rows, setRows] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      const { data, error } = await supabase
        .from('first_aid_data')
        .select('*')
        .order('priority', { ascending: true })
        .order('title', { ascending: true });
      if (error) setError(error.message);
      setRows(data ?? []);
      setLoading(false);
    })();
  }, []);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-semibold">Items</h2>
        <div className="flex gap-2">
          <Link href="/categories" className="px-3 py-2 rounded-lg bg-slate-200 text-slate-800">Categories</Link>
          <Link href="/new" className="px-3 py-2 rounded-lg bg-blue-600 text-white">+ New</Link>
        </div>
      </div>
      <Card>
        <div className="p-2">
          {loading && <p className="text-sm text-slate-500">Loading...</p>}
          {error && <p className="text-sm text-red-600">{error}</p>}
        </div>
        <div className="overflow-x-auto">
          <table className="min-w-full text-sm">
            <thead>
              <tr className="text-left text-slate-500">
                <th className="py-3 px-4">Title</th>
                <th className="py-3 px-4">Category</th>
                <th className="py-3 px-4">Priority</th>
                <th className="py-3 px-4">Video</th>
                <th className="py-3 px-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r: any, idx: number) => (
                <tr key={r.id} className={idx % 2 ? 'bg-slate-50' : ''}>
                  <td className="py-3 px-4 font-medium text-slate-800">{r.title}</td>
                  <td className="py-3 px-4">{r.category}</td>
                  <td className="py-3 px-4">{r.priority}</td>
                  <td className="py-3 px-4">{r.videoUrl ? 'Yes' : '-'}</td>
                  <td className="py-3 px-4">
                    <Link href={`/edit/${r.id}`} className="text-blue-600 hover:underline">Edit</Link>
                  </td>
                </tr>
              ))}
              {!loading && rows.length === 0 && (
                <tr>
                  <td colSpan={5} className="py-6 px-4 text-center text-slate-500">No items yet</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  );
} 