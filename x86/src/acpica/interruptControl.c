#include "acpi.h"

/*
 * @brief Register new interrupt with given number
 * 
 * @param interruptLevel: IRQ number
 * @param handler: Function to handle interrupt
 * @param context: Arguments for handler
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsInstallInterruptHandler(UINT32 interruptLevel, ACPI_OSD_HANDLER handler, void *context)
{
    return AE_OK;
}

/*
 * @brief Unregister given interrupt
 * 
 * @param interruptNumber: 
 * @param handler: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsRemoveInterruptHandler(UINT32 interruptNumber, ACPI_OSD_HANDLER handler)
{
    return AE_OK;
}