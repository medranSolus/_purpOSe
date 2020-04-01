#include "acpi.h"

/*
 * @brief Return process ID.
 * 
 * @return ACPI_THREAD_ID: 
 */
ACPI_THREAD_ID AcpiOsGetThreadId()
{
    return 0;
}

/*
 * @brief Create new thread/process with entry point in function and params defined in context.
 * 
 * @param type: 
 * @param function: 
 * @param context: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsExecute(ACPI_EXECUTE_TYPE type, ACPI_OSD_EXEC_CALLBACK function, void *context)
{
    function(context);
    return AE_OK;
}

/*
 * @brief Put current thread/process to sleep.
 * 
 * @param milliseconds: 
 */
void AcpiOsSleep(UINT64 milliseconds)
{
}

/*
 * @brief Put current thread/proccess to sleep.
 * 
 * @param microseconds: 
 */
void AcpiOsStall(UINT32 microseconds)
{
}