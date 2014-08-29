# Formbuilder.registerField 'checkbox',
Formbuilder.doNotRegisterField 'checkbox',

  order: 10

  view: """
    <% for (i in (rf.get(Formbuilder.options.mappings.OPTIONS) || [])) { %>
      <div>
        <label class='fb-option'>
          <input type='checkbox' <%= rf.get(Formbuilder.options.mappings.OPTIONS)[i].checked && 'checked' %> onclick="javascript: return false;" />
          <%= rf.get(Formbuilder.options.mappings.OPTIONS)[i].label %>
        </label>
      </div>
    <% } %>
  """

  edit: """
    <div class='fb-edit-section-header'>Option</div>

    <div class='option' data-rv-each-option='model.<%= Formbuilder.options.mappings.OPTIONS %>'>
      <input type="checkbox" class='js-default-updated' data-rv-checked="option:checked" />
      <input type="text" data-rv-input="option:label" class='option-label-input' />
    </div>
  """

  addButton: """
    <span class="symbol"><span class="fa fa-square-o"></span></span> Checkbox
  """

  defaultAttributes: (attrs) ->
    attrs.field_options.options = [
      label: "",
      checked: false
    ]

    attrs