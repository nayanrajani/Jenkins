# Section-9-Jenkins&Email

## Install Mail Plugin

- mailer (already installed)

## Integrate Jenkins and AWS Simple Email Service

- login to AWS
  - SES
    - create identity with email
      - verify it on your email

- In jenkins
  - manage jenkins
    - go to system 
      - Jenkins Location
        - System Admin e-mail address
          - add your email address

      - E-mail Notification (scroll to bottom and click on advance as well)
        - SMTP server: email-smtp.ap-south-1.amazonaws.com (you will get this on AWS under SES under SMTP setting)
        - Default user e-mail suffix: [blank]
        - checkbox use SMTP Authentication
          - for this:
            - (you will get this on AWS under SES under SMTP setting and create SMTP credentials, then give it a name)
            - create and download it and paste it below accordingly
          - User Name: Copy and paste it
          - Password: Copy and paste it
          - choose checkbox for Use SSL
          - SMTP Port: Copy and paste it from SMTP settings page[TLS Wrapper Port], i have used 465
          - Reply-To Address: add email address again
        - Test configuration by sending test e-mail
          - Test e-mail recipient: type email ther if it doesn't pop up
          - test configuration

### Integrate Jenkins and Gmail [alternate to AWS]

- search on google for smtp google
- User Name: Email
- Password: GMail Password
- choose checkbox for Use SSL
- SMTP Port: Copy and paste it from google
- Reply-To Address: add email address again

- Enable the less secure apps on google
- test configuration by sending test e-mail

### Add notifications to your jobs

- go to jenkins
  - go to ENV Job
    - configure
      - Post build Action
        - add
          - EMail notfication
            - Recipients: type your email here
            - choose both option
      - build
        - type and do a mistake to check
    - Save
  - build now
    - it will fail wait for the notification on your mailer
  - revert the mistake
  - build now
    - check the mail again.