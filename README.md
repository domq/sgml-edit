sgml-edit
=========

Wanna-be to `sgml-mode` as `psgml-edit` used to be to `psgml`, back in the day.

For now, there's just that one function `sgml-split-element`. If you want to
bind it to C-c RET, add this to your `.emacs`:

      (eval-after-load "sgml-mode"
          '(progn
              (require 'sgml-edit)
              (define-key html-mode-map "\C-c\r" 'sgml-split-element)))

That is all.
