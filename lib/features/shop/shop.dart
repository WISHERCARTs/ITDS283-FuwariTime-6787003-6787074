// import 'package:flutter/material.dart';
// // 💡 เช็ค Path ให้ตรงกับโฟลเดอร์ในโปรเจกต์ของคุณด้วยนะครับ
// import 'package:fuwari_time/features/home/widgets/top_bar.dart';
// import 'package:fuwari_time/features/home/widgets/bottom_nav_bar.dart';

// class Shop extends StatefulWidget {
//   const Shop({super.key});
//   @override
//   ShopState createState() => ShopState();
// }

// class ShopState extends State<Shop> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFF8F0),
//       // 💡 เรียกใช้ BottomNavBar และส่งค่า 2 เพื่อไฮไลท์ปุ่ม Shop
//       bottomNavigationBar: const BottomNavBar(currentIndex: 2),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 💡 1. เรียกใช้ TopBar (เมนูด้านบน)
//               const TopBar(),
              
//               const SizedBox(height: 24),
              
//               // 💡 2. หัวข้อ "Shop"
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24),
//                 child: Text(
//                   "Shop",
//                   style: TextStyle(
//                     color: Color(0xFF1F2937),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // 💡 3. ตารางรายการสินค้า (Grid View)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: GridView.count(
//                   shrinkWrap: true, // สำคัญ! เพื่อให้ใช้ร่วมกับ SingleChildScrollView ได้
//                   physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อนซ้อนกัน
//                   crossAxisCount: 2, // แบ่งเป็น 2 คอลัมน์
//                   crossAxisSpacing: 16, // ระยะห่างแนวนอน
//                   mainAxisSpacing: 16, // ระยะห่างแนวตั้ง
//                   childAspectRatio: 0.8, // สัดส่วนความกว้าง:ความสูง ของการ์ดสินค้า
//                   children: [
//                     // สินค้าชิ้นที่ 1
//                     _buildShopItem(
//                       title: "Rythm",
//                       category: "Decoration",
//                       price: "150",
//                       imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/kl3914on_expires_30_days.png",
//                     ),
//                     // สินค้าชิ้นที่ 2
//                     _buildShopItem(
//                       title: "Bacon Hotdog",
//                       category: "Decoration",
//                       price: "200",
//                       imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/0kgsyagc_expires_30_days.png",
//                     ),
//                     // สินค้าชิ้นที่ 3
//                     _buildShopItem(
//                       title: "Slava",
//                       category: "Furniture",
//                       price: "350",
//                       imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/i36w7fh5_expires_30_days.png",
//                     ),
//                     // สินค้าชิ้นที่ 4
//                     _buildShopItem(
//                       title: "Orange 7",
//                       category: "Decoration",
//                       price: "120",
//                       imageUrl: "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/h94kqwgy_expires_30_days.png",
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================
//   // ฟังก์ชันย่อยสำหรับวาด "การ์ดสินค้า" แต่ละชิ้น
//   // ==========================================
//   Widget _buildShopItem({
//     required String title,
//     required String category,
//     required String price,
//     required String imageUrl,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x1A000000),
//             blurRadius: 6,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // รูปภาพสินค้า (ใช้ Expanded เพื่อให้รูปยืดเต็มพื้นที่ที่เหลือ)
//           Expanded(
//             child: Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
          
//           // ชื่อสินค้า
//           Text(
//             title,
//             style: const TextStyle(
//               color: Color(0xFF1F2937),
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
          
//           // หมวดหมู่ และ ราคา
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 category,
//                 style: const TextStyle(
//                   color: Color(0xFF6B7280),
//                   fontSize: 11,
//                 ),
//               ),
//               // ปุ่มราคา (เหรียญ)
//               InkWell(
//                 onTap: () {
//                   print('กดซื้อ $title');
//                   // TODO: ใส่ Action ตอนกดซื้อสินค้าตรงนี้
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFEF9C3), // สีเหลืองอ่อน
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Image.network(
//                         "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/y0beqz0yoq/siq2ut46_expires_30_days.png",
//                         width: 12,
//                         height: 12,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         price,
//                         style: const TextStyle(
//                           color: Color(0xFFA16207),
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }