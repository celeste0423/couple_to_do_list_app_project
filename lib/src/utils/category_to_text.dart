String CategoryToText(String category) {
  switch (category) {
    case '1travel':
      return '여행';
    case '2meal':
      return '식사';
    case '3activity':
      return '액티비티';
    case '4culture':
      return '문화 활동';
    case '5study':
      return '자기계발';
    case '6etc':
      return '기타';
    default:
      return '카테고리';
  }
}
