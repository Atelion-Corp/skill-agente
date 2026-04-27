---
name: design-tinymce
description: Implement rich text editors in web applications using TinyMCE, Tiptap, or Quill — WYSIWYG editors, markdown editors, collaborative editing, custom toolbars. Use when user wants a text editor, rich content input, blog post editor, document editor, or any editable content area in web.
license: MIT
---

# design-tinymce — Editores de Texto Web

Editores WYSIWYG y rich text: TinyMCE, Tiptap, Quill. Para blogs, CMS, docs, forms con rich content.

## Cuándo usar

- "editor de texto", "WYSIWYG", "rich text editor"
- "editor de blog", "editor de documentos", "editor de contenido"
- "Notion-like editor", "markdown editor", "inline editing"
- "TinyMCE", "Tiptap", "Quill"

## Comparativa de opciones

| Librería | Cuándo usar | Peso | Licencia |
|----------|-------------|------|----------|
| **TinyMCE** | Máximo features, CMS enterprise | ~400KB | Free + Cloud |
| **Tiptap** | React/Next.js, extensible, Notion-like | ~80KB | MIT |
| **Quill** | Simple, bien documentado | ~100KB | BSD |
| **Editor.js** | Block-based (tipo Notion) | ~30KB | Apache |

**Recomendación para Next.js/React: Tiptap** (MIT, extensible, modern API)

---

## Opción 1: Tiptap (recomendado para React)

```bash
npm install @tiptap/react @tiptap/pm @tiptap/starter-kit
# Extensiones adicionales:
npm install @tiptap/extension-placeholder @tiptap/extension-image @tiptap/extension-link
```

### Setup básico

```tsx
'use client'
import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import Placeholder from '@tiptap/extension-placeholder'

export function RichEditor({ onChange }: { onChange?: (html: string) => void }) {
  const editor = useEditor({
    extensions: [
      StarterKit,
      Placeholder.configure({ placeholder: 'Escribe aquí...' }),
    ],
    content: '<p>Contenido inicial</p>',
    onUpdate: ({ editor }) => {
      onChange?.(editor.getHTML())
    },
  })

  return (
    <div className="border border-zinc-200 rounded-lg overflow-hidden">
      <Toolbar editor={editor} />
      <EditorContent
        editor={editor}
        className="prose max-w-none p-4 min-h-[200px] focus:outline-none"
      />
    </div>
  )
}
```

### Toolbar

```tsx
import { Editor } from '@tiptap/react'

function Toolbar({ editor }: { editor: ReturnType<typeof useEditor> }) {
  if (!editor) return null

  return (
    <div className="flex gap-1 p-2 border-b border-zinc-200 bg-zinc-50 flex-wrap">
      <button
        onClick={() => editor.chain().focus().toggleBold().run()}
        className={`px-2 py-1 rounded text-sm font-medium ${editor.isActive('bold') ? 'bg-zinc-900 text-white' : 'hover:bg-zinc-200'}`}
      >
        B
      </button>
      <button
        onClick={() => editor.chain().focus().toggleItalic().run()}
        className={`px-2 py-1 rounded text-sm italic ${editor.isActive('italic') ? 'bg-zinc-900 text-white' : 'hover:bg-zinc-200'}`}
      >
        I
      </button>
      <button
        onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()}
        className={`px-2 py-1 rounded text-sm ${editor.isActive('heading', { level: 2 }) ? 'bg-zinc-900 text-white' : 'hover:bg-zinc-200'}`}
      >
        H2
      </button>
      <button
        onClick={() => editor.chain().focus().toggleBulletList().run()}
        className={`px-2 py-1 rounded text-sm ${editor.isActive('bulletList') ? 'bg-zinc-900 text-white' : 'hover:bg-zinc-200'}`}
      >
        •—
      </button>
      <button
        onClick={() => editor.chain().focus().toggleCodeBlock().run()}
        className={`px-2 py-1 rounded text-sm font-mono ${editor.isActive('codeBlock') ? 'bg-zinc-900 text-white' : 'hover:bg-zinc-200'}`}
      >
        {'</>'}
      </button>
    </div>
  )
}
```

### Con imágenes y links

```bash
npm install @tiptap/extension-image @tiptap/extension-link
```

```tsx
import Image from '@tiptap/extension-image'
import Link from '@tiptap/extension-link'

const editor = useEditor({
  extensions: [
    StarterKit,
    Image.configure({ inline: false, allowBase64: true }),
    Link.configure({ openOnClick: false }),
  ],
})

// Insertar imagen
editor?.chain().focus().setImage({ src: '/imagen.jpg', alt: 'desc' }).run()

// Insertar link
editor?.chain().focus().setLink({ href: 'https://...' }).run()
```

---

## Opción 2: TinyMCE (máxima potencia)

```bash
npm install @tinymce/tinymce-react
```

```tsx
'use client'
import { Editor } from '@tinymce/tinymce-react'
import { useRef } from 'react'

export function TinyMCEEditor({ onChange }: { onChange?: (content: string) => void }) {
  const editorRef = useRef<any>(null)

  return (
    <Editor
      apiKey="tu-api-key"  // gratis en tiny.cloud
      onInit={(evt, editor) => (editorRef.current = editor)}
      initialValue="<p>Contenido inicial</p>"
      onEditorChange={(content) => onChange?.(content)}
      init={{
        height: 400,
        menubar: false,
        plugins: [
          'advlist', 'autolink', 'lists', 'link', 'image', 'charmap',
          'preview', 'searchreplace', 'visualblocks', 'code',
          'fullscreen', 'insertdatetime', 'media', 'table', 'code', 'wordcount'
        ],
        toolbar:
          'undo redo | blocks | bold italic | alignleft aligncenter ' +
          'alignright alignjustify | bullist numlist | removeformat | code',
        skin: 'oxide-dark',  // tema oscuro
        content_css: 'dark',
      }}
    />
  )
}
```

### TinyMCE sin API key (self-hosted)

```bash
npm install tinymce
```

```tsx
import { Editor } from '@tinymce/tinymce-react'

<Editor
  tinymceScriptSrc="/tinymce/tinymce.min.js"  // servido localmente
  // resto de config igual
/>
```

---

## Opción 3: Editor.js (block-based, tipo Notion)

```bash
npm install @editorjs/editorjs @editorjs/header @editorjs/list @editorjs/code @editorjs/image
```

```tsx
'use client'
import EditorJS from '@editorjs/editorjs'
import Header from '@editorjs/header'
import List from '@editorjs/list'
import { useEffect, useRef } from 'react'

export function BlockEditor({ onChange }: { onChange?: (data: any) => void }) {
  const editorRef = useRef<EditorJS>()
  const holderRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!holderRef.current || editorRef.current) return

    editorRef.current = new EditorJS({
      holder: holderRef.current,
      tools: {
        header: Header,
        list: List,
      },
      onChange: async (api) => {
        const data = await api.saver.save()
        onChange?.(data)
      },
    })

    return () => { editorRef.current?.destroy(); editorRef.current = undefined }
  }, [])

  return <div ref={holderRef} className="prose max-w-none min-h-[200px]" />
}
```

---

## Persistencia (guardar contenido)

```tsx
// Obtener HTML (Tiptap)
const html = editor.getHTML()
const json = editor.getJSON()  // formato serializable

// Guardar en DB (ejemplo con fetch)
await fetch('/api/content', {
  method: 'POST',
  body: JSON.stringify({ content: html }),
})

// Restaurar contenido guardado
editor.commands.setContent(savedHtml)
```

## Estilos del contenido (prose)

```bash
npm install @tailwindcss/typography
```

```tsx
// tailwind.config.js
plugins: [require('@tailwindcss/typography')]

// EditorContent
<EditorContent className="prose prose-zinc dark:prose-invert max-w-none p-4" />
```

## Output

- Editor funcional con toolbar
- Persistencia de HTML/JSON
- Estilos con @tailwindcss/typography
- Fallback para SSR (dynamic import con `ssr: false`)

## SSR (Next.js)

```tsx
const RichEditor = dynamic(() => import('./RichEditor'), { ssr: false })
```
