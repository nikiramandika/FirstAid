"use client";
import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabaseClient';

export default function EditCategory() {
  const router = useRouter();
  const params = useParams();
  const id = Number(params?.id);

  const [name, setName] = useState('');
  const [color, setColor] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      const { data, error } = await supabase.from('categories').select('*').eq('id', id).single();
      if (error) setError(error.message);
      else {
        setName(data?.name ?? '');
        setColor(data?.color ?? '');
      }
      setLoading(false);
    })();
  }, [id]);

  const save = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const { error } = await supabase.from('categories').update({ name, color }).eq('id', id);
    setSaving(false);
    if (error) setError(error.message);
    else router.push('/categories');
  };

  const remove = async () => {
    if (!confirm('Hapus kategori ini? Item yang refer ke nama ini tidak otomatis berubah.')) return;
    const { error } = await supabase.from('categories').delete().eq('id', id);
    if (error) setError(error.message);
    else router.push('/categories');
  };

  if (loading) return <p>Loading...</p>;

  return (
    <div className="max-w-lg">
      <h2 className="text-xl font-semibold mb-4">Edit Category</h2>
      <form onSubmit={save} className="space-y-3">
        <input className="w-full rounded-lg border border-slate-300 px-3 py-2" placeholder="Name" value={name} onChange={(e) => setName(e.target.value)} required />
        <input className="w-full rounded-lg border border-slate-300 px-3 py-2" placeholder="Color (optional)" value={color} onChange={(e) => setColor(e.target.value)} />
        {error && <p className="text-red-600 text-sm">{error}</p>}
        <div className="flex gap-2">
          <button disabled={saving} className="px-3 py-2 rounded-lg bg-blue-600 text-white">{saving ? 'Saving...' : 'Save'}</button>
          <button type="button" onClick={remove} className="px-3 py-2 rounded-lg bg-red-600 text-white">Delete</button>
          <button type="button" onClick={() => router.push('/categories')} className="px-3 py-2 rounded-lg bg-slate-200">Cancel</button>
        </div>
      </form>
    </div>
  );
} 