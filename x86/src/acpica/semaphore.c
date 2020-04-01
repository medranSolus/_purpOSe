#include "acpi.h"

/*
 * @brief Allocate memory for new mutex and pass it to outHandle.
 * 
 * @param outHandle: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsCreateMutex(ACPI_MUTEX *outHandle)
{
    return AE_NO_MEMORY;
}

/*
 * @brief Destroy mutex
 * 
 * @param handle: 
 */
void AcpiOsDeleteMutex(ACPI_MUTEX handle)
{
}

/*
 * @brief Get lock on mutex.
 * 
 * @param handle: 
 * @param timeout: 0: if lock not possible leave; >0: if lock not possible wait for timeout ms and leave; 0<: wait till lock possible.
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsAcquireMutex(ACPI_MUTEX handle, UINT16 timeout)
{
    return AE_OK;
}

/*
 * @brief Release lock on mutex.
 * 
 * @param handle: 
 */
void AcpiOsReleaseMutex(ACPI_MUTEX handle)
{
}

/*
 * @brief Create semaphore with initial count in it.
 * 
 * @param maxUnits: (ignore)
 * @param initialUnits: 
 * @param outHandle: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsCreateSemaphore(UINT32 maxUnits, UINT32 initialUnits, ACPI_SEMAPHORE *outHandle)
{
    return AE_OK;
}

/*
 * @brief Delete semaphore.
 * 
 * @param handle: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsDeleteSemaphore(ACPI_SEMAPHORE handle)
{
    return AE_OK;
}

/*
 * @brief Increment semaphore.
 * 
 * @param handle: 
 * @param units: Max number of times to call sem_wait.
 * @param timeout: 0: if increment not possible leave; >0: if increment not possible wait for timeout ms and leave; 0<: wait till increment possible.
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsWaitSemaphore(ACPI_SEMAPHORE handle, UINT32 units, UINT16 timeout)
{
    return AE_OK;
}

/*
 * @brief Decrement semaphore.
 * 
 * @param handle: 
 * @param units: Number of times to call sem_sig.
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsSignalSemaphore(ACPI_SEMAPHORE handle, UINT32 units)
{
    return AE_OK;
}

/*
 * @brief Allocate new spinlock and leave it in outHandle.
 * 
 * @param outHandle: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsCreateLock(ACPI_SPINLOCK *outHandle)
{
    return AE_OK;
}

/*
 * @brief Delete spinlock.
 * 
 * @param handle: 
 */
void AcpiOsDeleteLock(ACPI_SPINLOCK handle)
{
}

/*
 * @brief Get lock and return cpu flags before lock.
 * 
 * @param handle: 
 * @return ACPI_CPU_FLAGS: 
 */
ACPI_CPU_FLAGS AcpiOsAcquireLock(ACPI_SPINLOCK handle)
{
    return 0;
}

/*
 * @brief Release lock and restore cpu flags.
 * 
 * @param handle: 
 * @param flags: 
 */
void AcpiOsReleaseLock(ACPI_SPINLOCK handle, ACPI_CPU_FLAGS flags)
{
}