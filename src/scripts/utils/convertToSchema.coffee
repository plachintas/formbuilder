
api =
  keysTo:
    'label': 'title'
    'description': 'description'

    'pattern': 'pattern'
    'min': 'minimum'
    'max': 'maximum'
    'minlength': 'minLength'
    'maxlength': 'maxLength'

    # extra view options
    'size': 'size'
    'field_type': 'field_type'
    'error_message': 'error_message'

  _getType: (field) ->
    type = ''
    switch field.field_type
      when 'text', 'paragraph', 'radio', 'dropdown', 'email', 'website', 'checkboxes'
        type = 'string'
      when 'checkbox' then type = 'boolean'
      when 'number'
        type = if field.field_options?.integer_only then 'integer' else 'number'
      else type = 'null'
    type

  _convertField: (field) ->
    data =
      type: @_getType(field)
      formbuilder: field

    switch field.field_type
      when 'email' then data.format = 'email'
      when 'website' then data.format = 'uri'

    flatField = _.extend {}, field, field.field_options

    _.each flatField, (value, key) =>
      switch key
        when 'min', 'max', 'minlength', 'maxlength'
          data[ @keysTo[key] ] = parseInt(value, 10)
        when 'description', 'pattern'
          data[ @keysTo[key] ] = value
        when 'size', 'field_type', 'error_message'
          data['viewOptions'] = {} unless data['viewOptions']
          data['viewOptions'][ @keysTo[key] ] = value
        when 'options'
          if field.field_type is 'checkbox'
            firstItem = value[0]
            data['default'] = if firstItem?.checked then 'true' else 'false'
          else if field.field_type in ['dropdown', 'radio', 'checkboxes']
            def = _.find value, (opt) -> opt.checked
            data['default'] = def.label if def

            data['enum'] = _.pluck value, 'label'

    data

  _convertFields: (fields) ->
    # unshift first group if it is not present
    if fields?[0].field_type isnt 'field_group'
      fields.unshift
        label: "untitled_group"
        field_type: "field_group"

    # prepare groups & fields
    groups = {}
    curGroup = null
    _.each fields, (field) ->
      if field.field_type is 'field_group'
        curGroup = field.label
        groups[curGroup] = []
      else if curGroup
        groups[curGroup].push field

    # building schema
    schema =
      type: 'object'
      properties: {}

    _.each groups, (groupFields, groupName) =>
      schema.properties[groupName] =
        type: 'object'
        properties: {}

      group = schema.properties[groupName]
      groupProps = group.properties

      _.each groupFields, (field) =>
        groupProps[field.label] = @_convertField field # todo? field.name

      # collect required fields
      reqFields = _.filter groupFields, (field) -> field.required
      if reqFields and reqFields.length
        group['required'] = _.pluck reqFields, 'label' # todo? 'name'


    schema


Formbuilder.convertToSchema = (fields) ->
  api._convertFields fields