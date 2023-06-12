;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Alexander Derevianko"
      user-mail-address "alexander0derevianko@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 18)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 18))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! lsp-java
  (require 'lsp-java-boot)
  (require 'dap-java)

  ;; to enable the lenses
  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
  (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
        (add-hook 'conf-javaprop-mode-hook #'lsp)
  (setf lombok-jar-path "/home/omen/.m2/repository/org/projectlombok/lombok/1.18.26/lombok-1.18.26.jar")
  (setq lsp-java-vmargs `(
                          "-XX:+UseParallelGC"
                          "-XX:GCTimeRatio=4"
                          "-XX:AdaptiveSizePolicyWeight=90"
                          "-Dsun.zip.disableMemoryMapping=true"
                          "-Xmx1G"
                          "-Xms100m"
                          ,(concat "-javaagent:" lombok-jar-path)
                          )
        )
  (add-hook 'java-mode-hook (lambda () (setq c-basic-offset 4
                                        tab-width 4
                                        indent-tabs-mode 'nil)))
  (setq lsp-java-format-settings-url "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml")
  (setq lsp-java-format-settings-profile "GoogleStyle")
  )
;;(setq c-basic-offset 4)
;;(setq-default tab-width 4)

(general-auto-unbind-keys)
(map! :leader
      (:prefix ("m" . "my")
               "c" #'comment-dwim
               (:prefix ("d" . "dap")
                        "c" #'dap-java-run-test-class
                        "m" #'dap-java-run-test-method
                        )
               (:prefix ("l" . "lsp")
                        "j" #'lsp-jt-browser
                        "i" #'lsp-java-organize-imports
                        "r" #'lsp-rename
                        "g d" #'lsp-goto-type-definition
                        )
               )
      "p f" 'nil
      "p f t" #'projectile-find-test-file
      )



;; add map for lsp-jt-browser
;; + lsp-jt-browser
;; + dap-java-run-test-class
;; + dap-java-run-test-method
