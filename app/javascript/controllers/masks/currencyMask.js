export default function currencyMask(value) {
  let digits = Number(String(value).replace(/\D/g, ""));
  if (!digits || digits === 0) {
    return "";
  }

  return (
    "$ " +
    String(digits)
      .padStart(3, "0")
      .replace(/(\d+)(\d{2})/g, "$1,$2")
      .replace(/(\d)(?=(\d{3})+\,)/g, "$1.")
  );
}
