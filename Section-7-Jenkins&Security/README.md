# Section-7-Jenkins&Security

## Allow users to sign up

- under manage jenkins
  - security -> Authentication
    - choose "Allow users to sign up"
  - save
  - open incognito and chek by doing a signup
- roll-back to the older settings

### Install a powerful security plugin

- go to plugins -> install -> Role-based Authorization
- after restart
- under manage jenkins
  - security -> Authentication
    - choose "Role based Strategy"
  - save
- check we got a new section named as "Manage and Assign Roles"

- manage jenkins
  - go to Security -> Users -> you will see the new user
    - create a user and login in incognito
      - you will not be able to signin
      - because of the new plugin.

### Ever heard about roles? Let's create a Read Only role | Assign the role that you created to a particular user

- go to "Manage and Assign Roles"
  - Manage roles
    - Global Roles
    - create a role
      - Admin/read-only/specific permission
      - add
        - checkbox for overall read-only and job read-only
      - save
    - Assign Role
      - User/group to add
        - type the name
          - nayan  [in my case]
            - add
      - now checkbox above table for nayan for read-only access
    - save
  - login to nayan user on incognito mode.

### Create a role to execute jobs, and assign that role to your user

- only for execution
- go to "Manage and Assign Roles"
  - Manage roles
    - Global Roles
    - create a role
      - Execution-Role
      - add
        - checkbox for overall read-only and job read-only, build
      - save
    - Assign Role
      - now checkbox above table for nayan for read-only access and execution role
    - save
  - login to nayan user on incognito mode.

### Learn how to restrict Jobs to users using Project Roles.

- we need to create a project role it is based on patterns to assign users in it.
- go to "Manage and Assign Roles"
  - Manage roles
    - Global Roles
      - create a role
        - Dev-Team
      - add
      - checkbox for overall read-only and job read-only
    - Project Roles
      - Role to add: Ansible
      - Pattern: ansible-.*
    - add
      - now you can mark checkbox for the resources to be allowed
    - save
  - assign roles
    - global roles
      - checkbox for Dev-Team for nayan user and remove execution role and read-only role
    - item roles
      - type nayan to add
        - checkbox for Ansible