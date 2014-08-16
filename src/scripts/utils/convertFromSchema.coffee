
api =
  keysFrom:
    # 'title': 'label'
    'description': 'description'

    'pattern': 'pattern'
    'minimum': 'min'
    'maximum': 'max'
    'minLength': 'minlength'
    'maxLength': 'maxlength'

  _getFieldType: (field) ->
    type = ''
    switch field.type
      when 'boolean' then type = 'checkbox'
      when 'number', 'integer' then type = 'number'
      when 'string'
        type = if field.enum then 'dropdown' else 'text'

    type

  _convertField: (fieldName, field, isRequired = false) ->
    data =
      label: fieldName
      required: isRequired
      field_type: @_getFieldType field
      field_options: {}

    opts = data.field_options

    if field.type is 'integer'
      opts.integer_only = true
    else if field.type is 'boolean' and field.default
      opts.default = field.default is 'true'

    _.each field, (value, key) =>
      if @keysFrom[key]
        opts[ @keysFrom[key] ] = value
      else if key is 'enum'
        opts.options = []
        _.each value, (item) =>
          opts.options.push
            label: item
            checked: field.default is item

    data

  _convertSchema: (schema) ->
    actionSchemaData = schema.properties.data
    groups = actionSchemaData.properties

    fields = []
    _.each groups, (group, groupName) =>
      fields.push
        field_type: 'field_group'
        label: groupName

      groupFields = group.properties
      requiredFields = group.required or []
      _.each groupFields, (field, fieldName) =>
        if field.formbuilder
          fields.push field.formbuilder
        else
          isFieldRequired = fieldName in requiredFields
          fields.push @_convertField fieldName, field, isFieldRequired

    fields

Formbuilder.convertFromSchema = (schema) ->
  api._convertSchema schema