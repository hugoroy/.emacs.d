;; OrgMode

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

    (setq org-agenda-files (list "~/org/fsfe.org"
                                 "~/org/tosdr.org" 
                                 "~/org/perso.org"))

;; org-caldav
;; https://mykolab.com/clients/emacs
(add-to-list 'load-path "~/.emacs.d/org-caldav")  
(require 'org-caldav)

;; Insert your own username on the second line, I think you need to add
;; the domain if it isn't mykolab.com, e.g. "foobar@mykolab.ch".
(setq org-caldav-url "https://totosh.ampoliros.net/iRony/calendars/hugo@ampoliros.net")

;; The name of your calendar, typically "Calendar" or similar
;(setq org-caldav-calendar-id "Tasks")
;(setq org-caldav-calendar-id "642e3b416c20-f08935537cb7-cd4e1e0f")
;(setq org-caldav-calendar-id "Calendar » Personal Calendar")
(setq org-caldav-calendar-id "6bd60f38716f-42671f0dd90f-8805d111")

;; Local file that gets events added on the phone
(setq org-caldav-inbox "~/org/tasks.org")

;; List of your org files here
(setq org-caldav-files org-agenda-files)

;; This is the tricky part - I needed this to get the time zone right
(setq org-icalendar-timezone "Europe/Paris")
(setq org-icalendar-date-time-format ";TZID=%Z:%Y%m%dT%H%M%S")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Vim

;; http://www.emacswiki.org/emacs/Evil#toc3
;; Vim layer 
    (add-to-list 'load-path "~/.emacs.d/evil")  
    (require 'evil)  
    (evil-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-buffer-choice "~/org/perso.org"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Integrate mutt with org-mode
;;; http://upsilon.cc/~zack/blog/posts/2010/02/integrating_Mutt_with_Org-mode/

;; standard org <-> remember stuff, RTFM
(require 'org-capture)

(setq org-default-notes-file "~/org/gtd.org")

(setq org-capture-templates
      (quote
       (("m"
         "Mail"
         entry
         (file+headline "~/org/gtd.org" "Incoming")
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
	   (substitute-in-file-name "$HOME/.mutt/bin/mutt-open") message)))

;; add support for "mutt:ID" links
(org-add-link-type "mutt" 'open-mail-in-mutt)
