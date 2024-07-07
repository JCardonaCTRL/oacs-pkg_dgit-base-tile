ad_library {

    Set of TCL procedures to handle base tile

    @author JC (jcardona@mednet.ucla.edu)
    @cvs-id $Id$
    @creation-date 2020-05-19

}

namespace eval dap::tile {}

## Private main functions
ad_proc -private dap::tile::setProperty {
    -tile_id:required
    -property:required
    -section:required
    -value:required
} {
    Set the property for one of the attributes.<br>
    This should still work for extended Tiles, any property not available should result in an exception.

    @option tile_id package_id of the tile instance
    @option property any defined property on the tile
    @section values allowed: DAC, DAI, DATC, DATI
} {

    set prefix ""
    switch [string tolower $section] {
        "dac" {
            set prefix "_dac_"
        }
        "dai" {
            set prefix "_dai_"
        }
        "datc" {
            set prefix "_datc_"
        }
        "dati" {
            set prefix "_dati_"
        }
    }
    with_catch errmsg {
        set result  [parameter::set_value -package_id $tile_id -parameter ${prefix}${property} -value $value]
        ctrl::acs_object::update_object -object_id $tile_id
    } {
        global errorInfo
        ns_log Error "Error set property $property with section $section to tile $tile_id.\n$errorInfo"
        set result "Property $property with section $section does not exists on tile $tile_id"
    }

    return $result
}

ad_proc -private dap::tile::getProperty {
    -tile_id:required
    -property:required
    -section:required
    {-default_value ""}
} {
    Get the value for the property.


    @option tile_id package_id of the tile instance
    @option property any defined property on the tile
    @section values allowed: DAC, DAI, DATC, DATI
} {
    set prefix ""
    switch [string tolower $section] {
        "dac" {
            set prefix "_dac_"
        }
        "dai" {
            set prefix "_dai_"
        }
        "datc" {
            set prefix "_datc_"
        }
        "dati" {
            set prefix "_dati_"
        }
    }

    set property ${prefix}${property}
    return [parameter::get -package_id $tile_id -parameter $property -default $default_value]
}

ad_proc -private dap::tile::setAppInternalProperty {
    -tile_id:required
    -property:required
    -value:required
} {
    Set the property for one of the attributes.<br>
    This should still work for extended Tiles, any property not available should result in an exception.
    <br><br>
    Reserved for mobile application internals and place in section "Dgit App Tile Internals".
    These variables should only be defined in the base Tile package

} {
    return  [dap::tile::setProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DAI" \
                -value $value]
}
## Public set property functions
ad_proc -public dap::tile::setTileInternalProperty {
    -tile_id:required
    -property:required
    -value:required
} {
    Set the property for one of the attributes.<br>
    This should still work for extended Tiles, any property not available should result in an exception.
    <br><br>
    Reserved for Tile packages to define internal properties and place in section "Dgit Tile Internals" package/tile level

} {
    return  [dap::tile::setProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DATI" \
                -value $value]
}

ad_proc -public dap::tile::setUserCustomProperty {
    -tile_id:required
    -property:required
    -value:required
} {
    Set the property for one of the attributes.<br>
    This should still work for extended Tiles, any property not available should result in an exception.
    <br><br>
    Reserved for Tiles to specify end user customizable properties and place in section "Dgit Tile Customs".
    Use the description field for prompt text package/tile level

} {
    return  [dap::tile::setProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DATC" \
                -value $value]
}

ad_proc -public dap::tile::setAppCustomProperty {
    -tile_id:required
    -property:required
    -value:required
} {
    Set the property for one of the attributes.<br>
    This should still work for extended Tiles, any property not available should result in an exception.
    <br><br>
    Reserved for mobile application internals and place in section "Dgit App Tile Customs".
    Inherited from the base tile package

} {
    return  [dap::tile::setProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DAC" \
                -value $value]
}
## Public get property functions
ad_proc -public dap::tile::getTileInternalProperty {
    -tile_id:required
    -property:required
    {-default_value ""}
} {
    Get the property for one of the attributes.<br>
    This should still work for extended Tiles, any property not available should result in an exception.
    <br><br>
    Reserved for Tile packages to define internal properties and place in section "Dgit Tile Internals" package/tile level

} {
    return  [dap::tile::getProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DATI" \
                -default_value $default_value]
}

ad_proc -public dap::tile::getUserCustomProperty {
    -tile_id:required
    -property:required
    {-default_value ""}
} {
    Get the value for the property.
    <br><br>
    Reserved for Tiles to specify end user customizable properties and place in section "Dgit Tile Customs".
    Use the description field for prompt text package/tile level

} {
    return  [dap::tile::getProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DATC" \
                -default_value $default_value]
}

ad_proc -public dap::tile::getAppInternalProperty {
    -tile_id:required
    -property:required
    {-default_value ""}
} {
    Get the value for the property.
    <br><br>
    Reserved for mobile application internals and place in section "Dgit App Tile Internals".
    These variables should only be defined in the base Tile package

} {
    return  [dap::tile::getProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DAI" \
                -default_value $default_value]
}

ad_proc -public dap::tile::getAppCustomProperty {
    -tile_id:required
    -property:required
    {-default_value ""}
} {
    Get the value for the property.
    <br><br>
    Reserved for mobile application internals and place in section "Dgit App Tile Customs".
    Inherited from the base tile package

} {
    return  [dap::tile::getProperty \
                -tile_id $tile_id \
                -property $property \
                -section "DAC" \
                -default_value $default_value]
}
## Public get specific functions
ad_proc -public dap::tile::getRefKey {
    -tile_id:required
} {
    Gets the apm package key *appRefKey
} {
    set package_key [apm_package_key_from_id $tile_id]
    return $package_key
}

ad_proc -public dap::tile::getVersion {
    -tile_id:required
} {
    Gets the apm package version *appVersion
} {
    set package_key [apm_package_key_from_id $tile_id]
    apm_version_get -package_key $package_key -array "tile_info"
    return $tile_info(version_name)
}

ad_proc -public dap::tile::getVersionId {
    -tile_id:required
} {
    Gets the apm package version *appVersion
} {
    set package_key [apm_package_key_from_id $tile_id]
    apm_version_get -package_key $package_key -array "tile_info"
    return $tile_info(version_id)
}

ad_proc -public dap::tile::getRefName {
    -tile_id:required
} {
    Gets the apm package pretty name *appRefName
} {
    set package_key [apm_package_key_from_id $tile_id]
    apm_version_get -package_key $package_key -array "tile_info"
    return $tile_info(pretty_name)
}

ad_proc -public dap::tile::getModuleName {
    -tile_id:required
} {
    Gets the module name *appCode*
} {
    return  [dap::tile::getAppCustomProperty \
                -tile_id $tile_id \
                -property "appCode"]
}

ad_proc -public dap::tile::getLastModified {
    -tile_id:required
} {
    Returns the last modified date and time of the tile (any changes to the properties (added/deleted/modified)
} {
    return [acs_object::get_element -object_id $tile_id -element last_modified_ansi]
}

ad_proc -public dap::tile::isDeployable? {
    -tile_id:required
} {
    Gets the deployable flag for the tile *deployableP*
} {
    return  [dap::tile::getAppCustomProperty \
                -tile_id $tile_id \
                -property "deployableP"]
}

ad_proc -public dap::tile::getIdFromAppCode {
    -app_code:required
} {
    Gets the tile id based on the appCode *tileId
} {
    return [db_string get "" -default -1]
}
