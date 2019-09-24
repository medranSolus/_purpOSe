#include "acpi.h"

/*
 * @brief Map physicallAddress to virtual and allocate new page if needed (address translation + malloc) (maybe new heap needed)
 * 
 * @param physicalAddress: 
 * @param length: 
 * @return void*: 
 */
void *AcpiOsMapMemory(ACPI_PHYSICAL_ADDRESS physicalAddress, ACPI_SIZE length)
{
    return physicalAddress;
}

/*
 * @brief Free page frame(s) alocated for physicall address with length and mark as free (maybe new heap needed)
 * 
 * @param where: 
 * @param length: 
 */
void AcpiOsUnmapMemory(void *where, ACPI_SIZE length)
{
}

/*
 * @brief Translate logicalAddress (virtual) to physicalAddress
 * 
 * @param logicalAddress: 
 * @param physicalAddress: 
 * @return ACPI_STATUS: 
 */
ACPI_STATUS AcpiOsGetPhysicalAddress(void *logicalAddress, ACPI_PHYSICAL_ADDRESS *physicalAddress)
{
    if (!physicalAddress || !logicalAddress)
        return AE_NULL_OBJECT;
    *physicalAddress = *((ACPI_PHYSICAL_ADDRESS *)logicalAddress);
    return AE_OK;
}

/*
 * @brief Dynamic memory allocation (just malloc, NULL on error)
 * 
 * @param size: 
 * @return void*: 
 */
void *AcpiOsAllocate(ACPI_SIZE size)
{
    return NULL;
}

/*
 * @brief Free dynamic memory
 * 
 * @param memory: 
 */
void AcpiOsFree(void *memory)
{
}

/*
 * @brief Check if memory is readable (if exist in page structure)
 * 
 * @param memory: 
 * @param length: 
 * @return BOOLEAN: 
 */
BOOLEAN AcpiOsReadable(void *memory, ACPI_SIZE length)
{
    return TRUE;
}

/*
 * @brief Check if memory is writable (if exist in page structure and write bit set)
 * 
 * @param memory: 
 * @param length: 
 * @return BOOLEAN: 
 */
BOOLEAN AcpiOsWritable(void *memory, ACPI_SIZE length)
{
    return TRUE;
}