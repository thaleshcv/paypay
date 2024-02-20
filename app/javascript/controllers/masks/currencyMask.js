export default function currencyMask(value) {
  const digits = Number(value).toFixed(2).replace(/\D/g, "");
  if (!digits || Number(digits) === 0) {
    return "";
  }

  return (
    "$ " +
    digits
      .padStart(3, "0")
      .replace(/(\d+)(\d{2})/g, "$1,$2")
      .replace(/(\d)(?=(\d{3})+\,)/g, "$1.")
  );
}
