import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lyra/theme/app_theme.dart';

class MaximiseMusicPlaying extends StatefulWidget {
  const MaximiseMusicPlaying({super.key});

  @override
  State<MaximiseMusicPlaying> createState() => _MaximiseMusicPlayingState(); 

}

class _MaximiseMusicPlayingState extends State<MaximiseMusicPlaying> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      
    )..repeat();
  }
  @override
    void dispose() {
      // Nhớ dispose controller khi widget không còn sử dụng để tránh memory leak
      _controller.dispose();
      super.dispose();
    }
  @override
  Widget build(BuildContext context){
    const double albumSize = 300.0;
    const double vinylSize = 380.0;
    const double vinylOffset = 90.0;

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // AppTheme.redPrimaryDark,
              Color(0xFF737272),
              Color(0xFF3C3434),
            ],
            stops: const [0.0, 1],
        ),
         borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
      child: Expanded(
          child: SingleChildScrollView(
            
            physics: const BouncingScrollPhysics(),
            child: Padding(padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text(
                              "Chúng Ta Của Tương Lai",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Sơn Tùng M-TP",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ]
                        ),
                        IconButton(
                          onPressed: () {
                            // Action đóng
                          },
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30),
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 40), 
              SizedBox(
                width: albumSize + vinylOffset+ 100,
                height: 500,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Đĩa than nằm dưới
                    Positioned(
                      left: vinylOffset,
                      child: RotationTransition(
                        turns: _controller,
                        child: Container(
                          width: vinylSize,
                          height: vinylSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent, // Màu nền đĩa
                           
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0), // Viền đĩa
                            child: Image.asset('assets/images/vinyl_record.png', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    // Album Art nằm trên
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/sontung_chungtacuahientai.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox (height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      
                    )
                      Text(
                        "About the artists",
                        style: TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 12),
                      Container (
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF2C2C2C),
                          image: const DecorationImage(
                              // Ảnh nghệ sĩ làm nền
                              image: AssetImage('assets/images/image 18.png'), // Cần thêm ảnh này
                              fit: BoxFit.cover,
                              opacity: 0.6,
                            ),
                        ),
                        child: Stack(
                          children:[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                                  stops: const [0.5, 1.0],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Sơn Tùng M-TP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "2,044,507 monthly listener",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Nguyễn Thanh Tùng, born in 1994, known professionally as Sơn Tùng M-TP, is a Vietnamese singer, songwriter...",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.white),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                        ),
                                        child: const Text("Follow",
                                            style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            )
                            









                          ]
                        )
                      ),
                      
                    ]
                )
              )

                  
              
              ],
            ),
            )
            
            

          ),

         
        ),
    );      
  }

  
}