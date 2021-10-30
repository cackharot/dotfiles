;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;; Code:
(general-auto-unbind-keys)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "cackharot"
      user-mail-address "cackharot@gmail.com")

(cond (IS-MAC
       (setq mac-command-modifier      'meta
             mac-option-modifier       'alt
             mac-right-option-modifier 'alt)))

;; (setq mac-option-modifier nil
;;       mac-command-modifier 'meta)

(xterm-mouse-mode 1)

;; (unmap! doom-leader-map "SPC SPC")
(map! :nv "C-d" #'evil-multiedit-match-symbol-and-next
      :nv "C-D" #'evil-multiedit-match-symbol-and-prev)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-vibrant)
(setq doom-theme 'doom-tomorrow-night)
;; (setq doom-theme 'doom-snazzy)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

(setq doom-font (font-spec :family "Fira Code" :size 18)
      doom-big-font (font-spec :family "Fira Code" :size 24)
      doom-variable-pitch-font (font-spec :family "ETBembo" :size 18)
      doom-unicode-font (font-spec :family "JuliaMono")
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))
;;doom-variable-pitch-font (font-spec :family "Alegreya" :size 18))

;; this requires zen
(add-hook! 'org-mode-hook #'mixed-pitch-mode)
(setq mixed-pitch-variable-pitch-cursor nil)
(setq +zen-text-scale 0.8)

(map! "M-g g" #'avy-goto-line)
(map! "M-g M-g" #'avy-goto-line)
(map! "M-g o" #'counsel-outline)

(global-subword-mode 1)

(setq ledger-binary-path "hledger")
(setq ledger-mode-should-check-version nil)
(setq ledger-report-links-in-register nil)
(setq ledger-post-amount-alignment-column 64)
(setq ledger-highlight-xact-under-point nil)

(defvar ledger-report-balance
  (list "bal" (concat ledger-binary-path " -f %(ledger-file) bal -V --cost")))
(defvar ledger-report-reg
  (list "reg" (concat ledger-binary-path " -f %(ledger-file) reg")))
(defvar ledger-report-payee
  (list "payee" (concat ledger-binary-path " -f %(ledger-file) reg @%(payee)")))
(defvar ledger-report-account
  (list "account" (concat ledger-binary-path " -f %(ledger-file) reg %(account)")))
(defvar ledger-report-monthly
  (list "balance" (concat ledger-binary-path " -f %(ledger-file) balance expenses "
                          "--tree --no-total --row-total --average --monthly")))

;; Personal Accounting
(global-set-key (kbd "C-c e") 'hledger-jentry)
(global-set-key (kbd "C-c j") 'hledger-run-command)

(setq ledger-reports
      (list ledger-report-balance
            ledger-report-reg
            ledger-report-payee
            ledger-report-account
            ledger-report-monthly))

;; enable some highlighting for CSV rules files
(add-to-list 'auto-mode-alist '("\\.rules$" . conf-mode))
;; (add-to-list 'auto-mode-alist '("\\.\\(h?ledger\\|journal\\|j\\)$" . ledger-mode))
;; (add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))
;; useful when running reports in a shell buffer
;; (defun highlight-negative-amounts nil (interactive)
;;        (highlight-regexp "\\(\\$-\\|-\\$\\)[.,0-9]+" (quote hi-red-b))
;; )

(setq haskell-stylish-on-save t)
(setq haskell-compile-cabal-build-command "make build")
(setq lsp-lens-enable nil)
(setq lsp-eldoc-enable-hover t)
(setq lsp-ui-doc-enable t)
(setq lsp-ui-peek-enable t)
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-sideline-show-code-actions t)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-modeline-diagnostics-enable t)

;; Cycle between snake case, camel case, etc.
;; (require 'string-inflection)
;; (global-set-key (kbd "C-c i") 'string-inflection-cycle)
;; (global-set-key (kbd "C-c C") 'string-inflection-camelcase)        ;; Force to CamelCase
;; (global-set-key (kbd "C-c L") 'string-inflection-lower-camelcase)  ;; Force to lowerCamelCase
;; (global-set-key (kbd "C-c J") 'string-inflection-java-style-cycle) ;; Cycle through Java styles

(use-package! string-inflection
  :commands (string-inflection-all-cycle
             string-inflection-toggle
             string-inflection-camelcase
             string-inflection-lower-camelcase
             string-inflection-kebab-case
             string-inflection-underscore
             string-inflection-capital-underscore
             string-inflection-upcase)
  :init
  (map! :leader :prefix ("c." . "naming convention")
        :desc "cycle" "." #'string-inflection-all-cycle
        :desc "toggle" "t" #'string-inflection-toggle
        :desc "CamelCase" "c" #'string-inflection-camelcase
        :desc "downCase" "d" #'string-inflection-lower-camelcase
        :desc "kebab-case" "k" #'string-inflection-kebab-case
        :desc "under_score" "_" #'string-inflection-underscore
        :desc "Upper_Score" "u" #'string-inflection-capital-underscore
        :desc "UP_CASE" "U" #'string-inflection-upcase)
  (after! evil
    (evil-define-operator evil-operator-string-inflection (beg end _type)
      "Define a new evil operator that cycles symbol casing."
      :move-point nil
      (interactive "<R>")
      (string-inflection-all-cycle)
      (setq evil-repeat-info '([?g ?~])))
    (define-key evil-normal-state-map (kbd "g~") 'evil-operator-string-inflection)))

(use-package! keycast
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast--update t)
          (add-to-list 'global-mode-string '("" mode-line-keycast)))
      (remove-hook 'pre-command-hook 'keycast--update)
      (setq global-mode-string (remove '("" mode-line-keycast " ") global-mode-string))))
  (setq keycast-substitute-alist '((evil-next-line nil nil)
                                   (evil-previous-line nil nil)
                                   (evil-forward-char nil nil)
                                   (evil-backward-char nil nil)
                                   (ivy-done nil nil)
                                   (self-insert-command nil nil)))
  (custom-set-faces!
    '(keycast-command :inherit doom-modeline-debug
                      :height 0.9)
    '(keycast-key :inherit custom-modified
                  :height 1.1
                  :weight bold)))

;; (defun to-underscore ()
;;   (interactive)
;;   (progn (replace-regexp "\\([A-Z]\\)" "_\\1" nil (region-beginning) (region-end))
;;          (downcase-region (region-beginning) (region-end))
;;   )
;; )

(add-hook 'elm-mode-hook 'elm-format-on-save-mode)

;; (setq flycheck-hledger-strict t)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (use-package flycheck-hledger
;;   :after (flycheck ledger-mode)
;;   :demand t)

(setq-default
 org-babel-load-languages '((shell . t)
                            (emacs-lisp . t)
                            (python . t)
                            ;; (R . t)
                            (haskell . t)
                            (ledger . t)))

(use-package hledger-mode
  :bind (:map hledger-mode-map
         ("C-c C-j" . hledger-run-command)
         ("TAB" . org-cycle)
         :map hledger-view-mode-map
         ("C-c C-n" . hledger-running-report-months))
  ;; :bind (("C-c j" . hledger-run-command)
  ;;        :map hledger-mode-map
  ;;        ("C-c e" . hledger-jentry)
  ;;        ("M-p" . hledger/prev-entry)
  ;;        ("M-n" . hledger/next-entry))
  :init
  (setq hledger-jfile
        (expand-file-name "/opt/LProjects/hledger-journal/all.journal"))

  ;; (setq hledger-email-secrets-file (expand-file-name "secrets.el"
  ;;                                                   emacs-assets-directory))
  ;; Expanded account balances in the overall monthly report are
  ;; mostly noise for me and do not convey any meaningful information.
  (setq hledger-show-expanded-report nil)

  ;;(when (boundp 'my-hledger-service-fetch-url)
  ;;  (setq hledger-service-fetch-url
  ;;        my-hledger-service-fetch-url))

  :config
  (add-hook 'hledger-view-mode-hook #'hl-line-mode)
  ;; (add-hook 'hledger-view-mode-hook #'center-text-for-reading)

  (add-hook 'hledger-view-mode-hook
            (lambda ()
              (run-with-timer 1
                              nil
                              (lambda ()
                                (when (equal hledger-last-run-command
                                             "balancesheet")
                                  ;; highlight frequently changing accounts
                                  (highlight-regexp "^.*\\(savings\\|fd\\|cash\\).*$")
                                  (highlight-regexp "^.*credit-card.*$"
                                                    'hledger-warning-face))))))

  (add-hook 'hledger-mode-hook
            (lambda ()
              (make-local-variable 'company-backends)
              (add-to-list 'company-backends 'hledger-company))))

(use-package hledger-input
  ;; :pin manual
  :load-path "packages/rest/hledger-mode/"
  :bind (("C-c e" . hledger-capture)
         :map hledger-input-mode-map
         ("C-c C-b" . popup-balance-at-point))
  :preface
  (defun popup-balance-at-point ()
    "Show balance for account at point in a popup."
    (interactive)
    (if-let ((account (thing-at-point 'hledger-account)))
        (message (hledger-shell-command-to-string (format " balance -N %s "
                                                          account)))
      (message "No account at point")))

  :config
  (setq hledger-input-buffer-height 20)
  (add-hook 'hledger-input-post-commit-hook #'hledger-show-new-balances)
  (add-hook 'hledger-input-mode-hook #'auto-fill-mode)
  (add-hook 'hledger-input-mode-hook
            (lambda ()
              (make-local-variable 'company-idle-delay)
              (setq-local company-idle-delay 0.1))))

;; (setq hledger-jfile
;;         (expand-file-name "/opt/LProjects/hledger-journal/all.journal"))

(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))


(use-package restclient
  :ensure t)


(with-eval-after-load 'org-superstar
  (setq org-superstar-item-bullet-alist
        '((?* . ?•)
          (?+ . ?➤)
          (?- . ?•)))
  (setq org-superstar-leading-bullet '(?\s)
        org-superstar-remove-leading-stars t)
  ;; (setq org-superstar-headline-bullets-list '(?\s))
  (setq
      org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))
  (setq org-superstar-special-todo-items t)
  ;; Enable custom bullets for TODO items
  (setq org-superstar-todo-bullet-alist
        '(("TODO" . ?☐)
          ("NEXT" . ?✒)
          ("HOLD" . ?✰)
          ("WAITING" . ?☕)
          ("CANCELLED" . ?✘)
          ("DONE" . ?✔)))
  (org-superstar-restart))
(setq org-ellipsis " ▼ ")

;; (remove-hook 'org-mode-hook #'org-superstar-mode)
(after! org
  (setq org-hide-leading-stars nil
        org-startup-indented nil
        org-indent-mode-turns-on-hiding-stars nil
        org-startup-with-inline-images t))

(use-package ranger
  :ensure t)
;; (setq ranger-preview-file true)

;;; config.el ends here
