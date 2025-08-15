"use client";
import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabaseClient';
import { useParams, useRouter } from 'next/navigation';

export default function EditItem() {
  const router = useRouter();
  const params = useParams();
  const id = Number(params?.id);

  const [categories, setCategories] = useState<any[]>([]);
  const [form, setForm] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      const [itemRes, catsRes] = await Promise.all([
        supabase.from('first_aid_data').select('*').eq('id', id).single(),
        supabase.from('categories').select('*').order('name', { ascending: true }),
      ]);
      if (itemRes.error) setError(itemRes.error.message);
      setForm(itemRes.data);
      setCategories(catsRes.data ?? []);
      setLoading(false);
    })();
  }, [id]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setForm((f: any) => ({ ...f, [name]: name === 'priority' ? Number(value) : value }));
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const { error } = await supabase.from('first_aid_data').update(form).eq('id', id);
    setSaving(false);
    if (error) setError(error.message);
    else router.push('/');
  };

  const handleDelete = async () => {
    if (!confirm('Hapus item ini?')) return;
    const { error } = await supabase.from('first_aid_data').delete().eq('id', id);
    if (error) setError(error.message);
    else router.push('/');
  };

  if (loading) return <p>Loading...</p>;

  return (
    <div className="bg-white rounded-xl shadow-sm ring-1 ring-slate-200 p-4">
      <h2 className="text-lg font-semibold mb-3">Edit Item</h2>
      <form onSubmit={handleSave} className="grid gap-3">
        <select name="category" value={form.category || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" required>
          <option value="">Pilih Kategori</option>
          {categories.map((c) => (
            <option key={c.id} value={c.name}>{c.name}</option>
          ))}
        </select>
        <input name="title" placeholder="Title" value={form.title || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" required />
        <textarea name="description" placeholder="Description" value={form.description || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" required />
        <textarea name="treatment" placeholder="Treatment" value={form.treatment || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        <textarea name="warnings" placeholder="Warnings" value={form.warnings || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        <textarea name="symptoms" placeholder="Symptoms" value={form.symptoms || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        <input name="iconName" placeholder="Icon Name" value={form.iconName || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        <input type="number" name="priority" placeholder="Priority" value={form.priority || 1} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        <input name="videoUrl" placeholder="Video URL" value={form.videoUrl || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        <input name="illustrationUrl" placeholder="Illustration URL" value={form.illustrationUrl || ''} onChange={handleChange} className="rounded-lg border border-slate-300 px-3 py-2" />
        {error && <p className="text-red-600 text-sm">{error}</p>}
        <div className="flex gap-2">
          <button disabled={saving} type="submit" className="px-3 py-2 rounded-lg bg-blue-600 text-white">{saving ? 'Menyimpan...' : 'Simpan'}</button>
          <button type="button" onClick={handleDelete} className="px-3 py-2 rounded-lg bg-red-600 text-white">Hapus</button>
          <button type="button" onClick={() => router.push('/')} className="px-3 py-2 rounded-lg bg-slate-200">Batal</button>
        </div>
      </form>
    </div>
  );
} 