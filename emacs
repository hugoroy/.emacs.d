; General
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(pandoc-directives
   (quote
    (("include" . pandoc--process-include-directive)
     ("lisp" . pandoc--process-lisp-directive)
     ("sc" . pandoc-sc-directive)
     ("Llap" . pandoc-Llap-directive)
     ("qtitle" . pandoc-qtitle-directive)))))

(global-visual-line-mode 1)

; MELPA 
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
   ;; For important compatibility libraries like cl-lib
   (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

; UTF-8
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

; Offset, tabs and indents
(setq c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(global-set-key (kbd "RET") 'newline-and-indent)

; Typing
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'fill-no-break-predicate 'fill-french-nobreak-p)
(setq sentence-end-double-space nil)

; Scrolling
(setq scroll-margin 5
scroll-conservatively 9999
scroll-step 1)

; Backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

; History
(savehist-mode 1)
(setq savehist-file "~/.emacs.d/savehist")
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

; Bind-Keys
(require 'bind-key)
(bind-key "C-+" 'text-scale-increase)
(bind-key "C--" 'text-scale-decrease)

; Undo Tree C-x u
(require 'undo-tree)
    
; Recent Files
(require 'recentf)
(recentf-mode 1)
(defun recentf-open-files-compl ()
 (interactive)
 (let* ((all-files recentf-list)
	(tocpl (mapcar (function 
	   (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
	(prompt (append '("File name: ") tocpl))
	(fname (completing-read (car prompt) (cdr prompt) nil nil)))
	(find-file (cdr (assoc-ignore-representation fname tocpl))))) 


; Highlight FIXMEs and TODOs
(add-hook 'c-mode-common-hook
	(lambda ()
		(font-lock-add-keywords nil
			'(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; Emacs Modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Naked emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(Toggle-frame-fullscreen) 
;(scroll-bar-mode 0)
;(tool-bar-mode 0)
;(menu-bar-mode 0)


;; See http://bzg.fr/emacs-hide-mode-line.html
(defvar-local hidden-mode-line-mode nil)
(defvar-local hide-mode-line nil)

(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global nil
  :variable hidden-mode-line-mode
  :group 'editing-basics
  (if hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
            mode-line-format nil)
    (setq mode-line-format hide-mode-line
          hide-mode-line nil))
  (force-mode-line-update)
  ;; Apparently force-mode-line-update is not always enough to
  ;; redisplay the mode-line
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
             hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
             "Use M-x hidden-mode-line-mode to make the mode-line appear."))))

;; Activate hidden-mode-line-mode
(hidden-mode-line-mode 1)

;; If you want to hide the mode-line in all new buffers
;; (add-hook 'after-change-major-mode-hook 'hidden-mode-line-mode)

;; Alternatively, you can paint your mode-line in White but then
;; you'll have to manually paint it in black again
;; (custom-set-faces
;;  '(mode-line-highlight ((t nil)))
;;  '(mode-line ((t (:foreground "white" :background "white"))))
;;  '(mode-line-inactive ((t (:background "white" :foreground "white")))))

;; A small minor mode to use a big fringe
(defvar bzg-big-fringe-mode nil)
(define-minor-mode bzg-big-fringe-mode
  "Minor mode to use big fringe in the current buffer."
  :init-value nil
  :global t
  :variable bzg-big-fringe-mode
  :group 'editing-basics
  (if (not bzg-big-fringe-mode)
      (set-fringe-style nil)
    (set-fringe-mode
     (/ (- (frame-pixel-width)
           (* 100 (frame-char-width)))
        2))))

;; Now activate this global minor mode
;(bzg-big-fringe-mode 1)

;; To activate the fringe by default and deactivate it when windows
;; are split vertically, uncomment this:
;; (add-hook 'window-configuration-change-hook
;;           (lambda ()
;;             (if (delq nil
;;                       (let ((fw (frame-width)))
;;                         (mapcar (lambda(w) (< (window-width w) fw))
;;                                 (window-list))))
;;                 (bzg-big-fringe-mode 0)
;;               (bzg-big-fringe-mode 1))))

;; Use a minimal cursor
;; (setq default-cursor-type 'hbar)

;; Get rid of the indicators in the fringe
;(mapcar (lambda(fb) (set-fringe-bitmap-face fb 'org-hide))
;        fringe-bitmaps)

;; Set the color of the fringe
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "white")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown-Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdwn\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mkdn\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("~/.mutt/tmp/*" . markdown-mode))
; YAML-Mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
; TeX-Mode
(load "tex-mode")
(add-to-list 'auto-mode-alist '("\\.latex\\'" . tex-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonctions pour pandoc-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Pandoc-Mode
(load "pandoc-mode")
(add-hook 'markdown-mode-hook 'pandoc-mode)
(setq pandoc-data-dir "~/.pandoc/mode")

;; https://github.com/joostkremers/pandoc-mode/issues/38
(defun pandoc-test-directive (ofmt &optional text)
  "Handle @@test directives in pandoc-mode."
  (cond
   ((string= ofmt "latex")
    (format "\\test{%s}" text))
   ((string= ofmt "html5")
    (format "<span class="test">%s</span>" text))
   (t text)))

(defun pandoc-sc-directive (ofmt &optional text)
  "Handle @@sc directives in pandoc-mode."
  (cond
   ((string= ofmt "latex")
    (format "\\textsc{%s}" text))
   ((string= ofmt "html5")
    (format "<span style='font-variant: small-caps'>%s</span>" text))
   (t text)))

(defun pandoc-qtitle-directive (ofmt &optional text)
  "Handle @@qtitle directives in pandoc-mode."
  (cond
   ((string= ofmt "latex")
    (format "\\begin{qtitle}%s\\end{qtitle}" text))
   ((string= ofmt "html5")
    (format "<div class='qtitle'>%s</div>" text))
   (t text)))

(defun pandoc-Llap-directive (ofmt &optional text)
  "Handle @@Llap directives in pandoc-mode."
  (cond
   ((string= ofmt "latex")
    (format "\\Llap{%s}" text))
   ((string= ofmt "html5")
    (format "<span class='Llap'>%s</span>" text))
   (t text)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; http://orgmode.org/guide/Activation.html#Activation
;; The following lines are always needed.  Choose your own keys.

;; http://orgmode.org/guide/Activation.html#Activation
;; The following lines are always needed.  Choose your own keys.
    (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)) ; not needed since Emacs 22.2
    (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
    (global-set-key "\C-cl" 'org-store-link)
    (global-set-key "\C-ca" 'org-agenda)
    (global-set-key "\C-cb" 'org-iswitchb)

;; http://orgmode.org/guide/Clean-view.html#Clean-view
;; Clean-indented-view of headlines instead of noisy view with countless *
    (add-hook 'org-mode-hook (lambda () (org-indent-mode t)) t)

;; http://orgmode.org/guide/Closing-items.html#Closing-items
     (setq org-log-done 'time)
     (setq org-log-done 'note)

;; org files
    (setq org-agenda-files (list "~/Org/agenda.org"
				 "~/Org/agenda.org_archive"
				 ))

;; todo states
    (setq org-todo-keywords
    '((sequence "TODO" "STARTED" "WAITING" "DONE")))

;; clocking and tags
(eval-after-load 'org
  '(progn
     (defun wicked/org-clock-in-if-starting ()
       "Clock in when the task is marked STARTED."
       (when (and (string= state "STARTED")
		  (not (string= last-state state)))
	 (org-clock-in)))
     (add-hook 'org-after-todo-state-change-hook
	       'wicked/org-clock-in-if-starting)
     (defadvice org-clock-in (after wicked activate)
      "Set this task's status to 'STARTED'."
      (org-todo "STARTED"))
    (defun wicked/org-clock-out-if-waiting ()
      "Clock out when the task is marked WAITING."
      (when (and (string= state "WAITING")
                 (equal (marker-buffer org-clock-marker) (current-buffer))
                 (< (point) org-clock-marker)
	         (> (save-excursion (outline-next-heading) (point))
		    org-clock-marker)
		 (not (string= last-state state)))
	(org-clock-out)))
    (add-hook 'org-after-todo-state-change-hook
	      'wicked/org-clock-out-if-waiting)))


;; MobileOrg
;(setq org-mobile-directory "~/Org/mobile")


;; org-caldav
;; https://mykolab.com/clients/emacs
(require 'org-caldav)

;; Insert your own username on the second line, I think you need to add
;; the domain if it isn't mykolab.com, e.g. "foobar@mykolab.ch".

;; The name of your calendar, typically "Calendar" or similar
; Tasks (bug: does not seem to accept DAV requests)
(setq org-caldav-calendar-id "1a96c7e155b7d0bb")
;(setq org-caldav-calendar-id "Org")

;; Local file that gets events added on the phone
(setq org-caldav-inbox "~/Org/caldav/totosh.org")

;; List of your org files here
(setq org-caldav-files org-agenda-files)

;; This is the tricky part - I needed this to get the time zone right
(setq org-icalendar-timezone "Europe/Paris")
(setq org-icalendar-date-time-format ";TZID=%Z:%Y%m%dT%H%M%S")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Email
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'notmuch "notmuch" "notmuch mail" t)

;;; Org-Mutt

;; standard org <-> remember stuff, RTFM
(require 'org-protocol)
(require 'org-capture)

(setq org-default-notes-file "~/Org/notes.org")

(setq org-capture-templates
      (quote
       (("m"
         "Mail"
         entry
         (file+headline "~/Org/mutt.org" "Incoming")
         "* TODO %^{Title}\n\n  Source: %u, %c\n\n  %i"
         :empty-lines 1)
        ;; ... more templates here ...
        )))
;; ensure that emacsclient will show just the note to be edited when invoked
;; from Mutt, and that it will shut down emacsclient once finished;
;; fallback to legacy behavior when not invoked via org-protocol.
(add-hook 'org-capture-mode-hook 'delete-other-windows)
(setq my-org-protocol-flag nil)
(defadvice org-capture-finalize (after delete-frame-at-end activate)
  "Delete frame at remember finalization"
  (progn (if my-org-protocol-flag (delete-frame))
         (setq my-org-protocol-flag nil)))
(defadvice org-capture-kill (after delete-frame-at-end activate)
  "Delete frame at remember abort"
  (progn (if my-org-protocol-flag (delete-frame))
         (setq my-org-protocol-flag nil)))
(defadvice org-protocol-capture (before set-org-protocol-flag activate)
  (setq my-org-protocol-flag t))

(defun open-mail-in-mutt (message)
  "Open a mail message in Mutt, using an external terminal.

Message can be specified either by a path pointing inside a
Maildir, or by Message-ID."
  (interactive "MPath or Message-ID: ")
  (shell-command
   (format "gnome-terminal -e \"%s %s\""
	   (substitute-in-file-name "$HOME/.email/org-mutt/mutt-open") message)))

;; add support for "mutt:ID" links
(org-add-link-type "mutt" 'open-mail-in-mutt)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Vim
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "SPC")

;; http://www.emacswiki.org/emacs/Evil#toc3
;; Vim layer 
(require 'evil)  
(evil-mode 1)

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)
(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)

;; Powerline
(require 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; Evil-Org
(require 'evil-org)
