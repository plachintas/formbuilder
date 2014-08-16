Formbuilder.registerField 'field_group',

  order: 0

  type: 'non_input'

  view: """
    <label class='section-name'><%= rf.get(Formbuilder.options.mappings.LABEL) %></label>
    <p><%= rf.get(Formbuilder.options.mappings.DESCRIPTION) %></p>
  """

  edit: """
  """

  addButton: """
    <span class='symbol'><span class='fa fa-minus'></span></span> Field Group
  """
