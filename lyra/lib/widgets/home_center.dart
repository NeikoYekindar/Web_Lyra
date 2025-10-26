import 'package:flutter/material.dart';

class HomeCenter extends StatelessWidget {
  const HomeCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF040404),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Căn trái
              crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
              children: [
                // Left Side - Image
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Image(
                              image: AssetImage('assets/images/HTH.png'),
                              fit: BoxFit.cover,
                            ),
                  
                ),

                // Right Side - Text Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Album',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            
                          ),
                          
                        ),
                        SizedBox(height: 45),
                        Text(
                          'Ai Cũng Phải Bắt Đầu Từ Đâu Đó',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sơn Tùng M-TP • Single',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(), // Đẩy container xuống dưới cùng
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green,
                                ),
                                child: Image(image: AssetImage('assets/images/HTH_icon.png'),fit: BoxFit.fill,),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'HIEUTHUHAI • 2023 • 13 songs, 39 min 44 sec ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
              ],
            )
            
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF7BB3F0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          
        ],
      )
    );
  }
}
