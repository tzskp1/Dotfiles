(defvar package-list
  '(
    yatex
    tuareg
    markdown-mode
    ddskk
    fsharp-mode
    )
  "packages to be installed")

(dolist (pkg package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))
