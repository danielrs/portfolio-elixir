export default function Enum(values) {
  for (let value of values) {
    this[value] = value;
  }
}
