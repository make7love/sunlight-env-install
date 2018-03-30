#!/usr/bin/env python

from sunlight_module import send_mail_module

import sys

email_content = " ".join(sys.argv[1:])

send_mail_module.fire_email(email_content)
