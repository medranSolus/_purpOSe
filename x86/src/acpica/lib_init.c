#include "acpi.h"

/*
 * @brief Called during OSL initialization.
 * 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsInitialize()
{ 
    return AE_OK; 
}

/*
 * @brief Callend during ACPICA shutingdow itself. Can dealloc memory from AcpiOsInitialize.
 * 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsTerminate()
{ 
    return AE_OK; 
}

/*
 * @brief Gets pointer from memory to RSDP.
 * 
 * @return ACPI_PHYSICAL_ADDRESS: 
 */
ACPI_PHYSICAL_ADDRESS AcpiOsGetRootPointer()
{
    ACPI_PHYSICAL_ADDRESS rsdp = 0;
    AcpiFindRootPointer(&rsdp);
    return rsdp;
}

/*
 * @brief Overrides names for existing ACPI objects.
 * 
 * @param predefinedObject: 
 * @param newValue: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsPredefinedOverride(const ACPI_PREDEFINED_NAMES *predefinedObject, ACPI_STRING *newValue)
{
    if (newValue)
        *newValue = NULL;
    return AE_OK;
}

/*
 * @brief Overides names of ACPI tables.
 * 
 * @param existingTable: 
 * @param newTable: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsTableOverride(ACPI_TABLE_HEADER *existingTable, ACPI_TABLE_HEADER **newTable)
{
    if (newTable)
        *newTable = NULL;
    return AE_OK;
}