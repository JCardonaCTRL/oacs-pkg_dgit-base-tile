<?xml version="1.0"?>
<queryset>

  <fullquery name="dap::tile::getIdFromAppCode.get">
    <querytext>
      select param_values.package_id as tile_id
      from apm_parameters         param
        join apm_parameter_values param_values on param_values.parameter_id = param.parameter_id
      where param.parameter_name    = '_dac_appCode'
        and param_values.attr_value = :app_code
    </querytext>
  </fullquery>

</queryset>
