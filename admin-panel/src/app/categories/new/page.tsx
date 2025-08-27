"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

const ICON_OPTIONS = [
  "medical_services",
  "bloodtype",
  "accessibility",
  "local_fire_department",
  "psychology",
  "warning",
  "flash_on",
];

export default function NewCategory() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [iconName, setIconName] = useState("medical_services");
  const [color, setColor] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    const { error } = await supabase
      .from("categories")
      .insert([{ name, iconName, color }]);
    setLoading(false);
    if (error) setError(error.message);
    else router.push("/categories");
  };

  return (
    <div className="max-w-lg">
      <h2 className="text-xl font-semibold mb-4">New Category</h2>
      <form onSubmit={submit} className="space-y-3">
        <input
          className="w-full rounded-lg border border-slate-300 px-3 py-2"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <div>
          <label className="block mb-1 font-medium">Icon</label>
          <div className="flex items-center gap-2">
            <span className="material-icons">{iconName}</span>
            <select
              className="w-full rounded-lg border border-slate-300 px-3 py-2"
              value={iconName}
              onChange={(e) => setIconName(e.target.value)}
            >
              {ICON_OPTIONS.map((i) => (
                <option key={i} value={i}>
                  {i}
                </option>
              ))}
            </select>
          </div>
        </div>

        <input
          className="w-full rounded-lg border border-slate-300 px-3 py-2"
          placeholder="Color (optional, e.g. #3182CE)"
          value={color}
          onChange={(e) => setColor(e.target.value)}
        />
        {error && <p className="text-red-600 text-sm">{error}</p>}
        <div className="flex gap-2">
          <button
            disabled={loading}
            className="px-3 py-2 rounded-lg bg-blue-600 text-white"
          >
            {loading ? "Saving..." : "Save"}
          </button>
          <button
            type="button"
            onClick={() => router.push("/categories")}
            className="px-3 py-2 rounded-lg bg-slate-200"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
