;;; sensitive.el --- A dead simple way to load sensitive information

;; CC BY Tim Visher

;; Author: Tim Visher <tim.visher@gmail.com>
;; Keywords: convenience
;; Package-Requires: ((emacs "24") (sequences "0.1.0))
;; Version: 1.0.0

;; This file is not part of GNU Emacs.

;; This work is licensed under the Creative Commons Attribution 3.0
;; Unported License. To view a copy of this license, visit
;; <http://creativecommons.org/licenses/by/3.0/> or send a letter to
;; Creative Commons, 444 Castro Street, Suite 900, Mountain View,
;; California, 94041, USA.

;;; Commentary:

;; This package is intended to make it dead simple to include
;; sensitive information in your public .emacs file. More people
;; publishing their .emacs file is a good thing for the world of Emacs
;; users and the more facilities people have for hiding the
;; information they need to load without having to jump through hoops
;; to load it should make that easier.

;;; Code:

(require 'cl-lib)
(require 'sequences)

(defgroup sensitive '()
  "Customization group for `sensitive`"
  :link '(url-link "http://github.com/timvisher/sensitive.el"))

(defcustom sensitive-root "~/sensitive"
  "Root directory to set sensitive vars from."
  :type  'directory
  :group 'sensitive)

;;;###autoload
(defun load-sensitive-files ()
  (if (file-directory-p sensitive-root)
      (cl-dolist (setting-file (cl-remove-if 'file-directory-p (sequences-file-seq sensitive-root)))
        (with-temp-buffer
          (insert-file-contents setting-file)
          (goto-char (point-min))
          (let ((package-name (intern (file-name-base (substring (file-name-directory setting-file) 0 -1))))
                (var-name     (intern (file-name-base setting-file)))
                (value        (read (current-buffer))))
            (message (format "Setting %s to %s after %s is loaded." (symbol-name var-name) value (symbol-name package-name) ))
            (eval-after-load package-name
              (set var-name value)))))
    (message (format "%s is not a directory." sensitive-root))))

(provide 'sensitive)

;;; Local Variables:
;;; tab-width:2
;;; indent-tabs-mode:nil
;;; lexical-binding:t
;;; End:
;;; sensitive.el ends here
