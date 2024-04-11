/**
 * Verify whether the string is empty or not
 * @param {string} value - is for method argument that requires validation
 * @return {boolean} - is for telling whether input string is empty or not
 */
export function isEmptyString(value: string): boolean {
  return (value == null || (typeof value === "string" && value.trim().length === 0));
}

/**
 * Verify whether the array is empty or not
 * @param {Array} value - is for method argument that requires validation
 * @return {boolean} - is for telling whether input array is empty or not
 */
export function isEmptyArray(value: []):boolean {
  return value.length == 0;
}


