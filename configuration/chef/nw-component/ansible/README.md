# Ansible Cookbook Generator

As most of the component cookbooks are identical to one another, save for
name swaps, this Ansible playbook can be used to generate or regenerate
these cookbooks to aid in mass updates. New cookbooks can be easily added
by appending entries to `hosts`.

Note that this will overwrite the manaaged files using templates or (rarely)
static assets, so care must be taken in how updates are managed. Files that
are not managed by this playbook are unaffected.

The `hosts` file contains an example entry; be sure to edit or remove it
when running the playbook.
