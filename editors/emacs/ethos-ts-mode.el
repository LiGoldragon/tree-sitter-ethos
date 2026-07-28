;;; ethos-ts-mode.el --- Tree-sitter mode for Ethos -*- lexical-binding: t; -*-

;; Package-Requires: ((emacs "29.1"))

;;; Commentary:

;; Tree-sitter-backed major mode for authored Ethos files.

;;; Code:

(require 'treesit)

(defgroup ethos-ts nil
  "Tree-sitter support for Ethos files."
  :group 'languages)

(defface ethos-ts-struct-face
  '((t :inherit font-lock-type-face :weight bold :foreground "#4EC9B0"))
  "Face for Ethos struct declarations."
  :group 'ethos-ts)

(defface ethos-ts-enum-face
  '((t :inherit font-lock-type-face :weight bold :foreground "#C586C0"))
  "Face for Ethos enum declarations."
  :group 'ethos-ts)

(defface ethos-ts-stream-face
  '((t :inherit font-lock-type-face :weight bold :foreground "#569CD6"))
  "Face for Ethos stream declarations."
  :group 'ethos-ts)

(defface ethos-ts-family-face
  '((t :inherit font-lock-type-face :weight bold :foreground "#DCDCAA"))
  "Face for Ethos family declarations."
  :group 'ethos-ts)

(defcustom ethos-ts-language-source
  '(ethos "https://github.com/LiGoldragon/tree-sitter-ethos")
  "Tree-sitter grammar source for Ethos."
  :type '(repeat sexp)
  :group 'ethos-ts)

(defvar ethos-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'ethos
   :feature 'comment
   '((comment) @font-lock-comment-face)

   :language 'ethos
   :feature 'literal
   '((pipe_text) @font-lock-string-face
     (integer) @font-lock-number-face
     (table_name) @font-lock-string-face)

   :language 'ethos
   :feature 'declaration
   '((namespace_entry
      name: (name) @ethos-ts-struct-face
      value: (struct_declaration))
     (namespace_entry
      name: (name) @ethos-ts-enum-face
      value: (enum_declaration))
     (namespace_entry
      name: (name) @ethos-ts-stream-face
      value: (stream_declaration))
     (namespace_entry
      name: (name) @ethos-ts-family-face
      value: (family_declaration))
     (namespace_entry
      name: (name) @font-lock-type-face)
     (field_declaration
      name: (name) @font-lock-property-name-face))

   :language 'ethos
   :feature 'variant
   '((unit_variant name: (variant_name (name) @font-lock-constant-face))
     (self_tagged_variant name: (variant_name (name) @font-lock-constant-face))
     (data_variant name: (variant_name (name) @font-lock-constant-face))
     (streaming_variant
      name: (variant_name (name) @font-lock-constant-face)
      relation: (stream_relation_keyword) @font-lock-keyword-face
      stream: (variant_name (name) @ethos-ts-stream-face)))

   :language 'ethos
   :feature 'macro
   '((stream_keyword) @font-lock-function-name-face
     (family_keyword) @font-lock-function-name-face
     (relation_keyword) @font-lock-function-name-face
     (vector_keyword) @font-lock-function-name-face
     (optional_keyword) @font-lock-function-name-face
     (scope_keyword) @font-lock-function-name-face
     (map_keyword) @font-lock-function-name-face
     (bytes_keyword) @font-lock-function-name-face
     (stream_field_key) @font-lock-property-name-face
     (family_field_key) @font-lock-property-name-face
     (family_key) @font-lock-builtin-face)

   :language 'ethos
   :feature 'reference
   '(((plain_reference name: (name) @font-lock-builtin-face)
      (:match "^(String\\|Integer\\|Boolean\\|Path)$" @font-lock-builtin-face))
     (plain_reference name: (name) @font-lock-type-face))))

(defun ethos-ts-mode-install-language-source ()
  "Register `ethos' in `treesit-language-source-alist'."
  (interactive)
  (add-to-list 'treesit-language-source-alist ethos-ts-language-source))

;;;###autoload
(define-derived-mode ethos-ts-mode prog-mode "Ethos"
  "Major mode for Ethos files."
  (unless (treesit-ready-p 'ethos)
    (ethos-ts-mode-install-language-source))
  (when (treesit-ready-p 'ethos)
    (treesit-parser-create 'ethos)
    (setq-local treesit-font-lock-settings ethos-ts-mode--font-lock-settings)
    (setq-local treesit-font-lock-feature-list
                '((comment)
                  (literal reference)
                  (macro variant declaration)))
    (treesit-major-mode-setup)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ethos\\'" . ethos-ts-mode))

(provide 'ethos-ts-mode)

;;; ethos-ts-mode.el ends here
