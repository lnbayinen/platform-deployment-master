sync_modules:
  local.saltutil.sync_all:
    - tgt: {{ data['id'] }}
