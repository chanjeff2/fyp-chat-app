import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/screens/camera/image_preview.dart';
import 'package:fyp_chat_app/screens/camera/video_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/chatroom.dart';

enum Source {
  chatroom,
  personalIcon,
  groupIcon
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key,
                      required this.source,
                      this.id,
                      this.chatroom,
                      this.sendCallback,
                    }) : super(key: key);

  final Source source;
  final String? id;
  final Chatroom? chatroom;
  final sendCallback;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {


  late final Future<bool> _getCameraFuture;
  final List<CameraDescription> _cameras = [];

  CameraController? controller;

  bool _isCameraPermissionGranted = false;

  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true; // on default uses rear cam
  bool _isVideoModeSelected = false; // on default it is photo mode

  bool _isRecordingInProgress = false; // State of recording video
  bool _isRecordingPaused = false;

  // scale
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Effect for switch camera button
  double rotatedRadian = 0;

  FlashMode? _currentFlashMode;

  // Number of user fingers touching screen
  int _pointers = 0;

  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  @override
  void initState() {
    // Hide the status bar
    _grantPermission();
    _getCameraFuture = _getCameras();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  @override
  void dispose() {
    // Make the status bar reappear
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    controller?.dispose();
    super.dispose();
  }

  void _grantPermission() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      print('Permission GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      onNewCameraSelected(_cameras[0]);
    } else {
      print('Permission DENIED');
    }
  }

  Future<bool> _getCameras() async {
    final cameraList = await availableCameras();
    setState(() {
      _cameras.addAll(cameraList);
    });
    print("Camera ready");
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize
    // We do nothing here
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    setState(() {
      controller = cameraController;
      _isRecordingPaused = false;
    });

    // Update UI if controller updated (Commented for now as no use)

    //  cameraController.addListener(() {
    //    if (mounted) setState(() {});
    //  });

    // Initialize controller and stuff
    try {
      await cameraController.initialize();

      await Future.wait([
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      await controller!.setFlashMode(FlashMode.off);
      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the initialized state
    setState(() {
      _isCameraInitialized = controller!.value.isInitialized;
    });
  }

  // Set the base scale to the current scale
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  // Pinch to zoom action
  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  // Tap and focus
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  // Action of taking photo
  Future<void> takePicture(BuildContext context) async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }
    try {
      XFile image = await cameraController.takePicture();
      if (widget.source == Source.chatroom) {
        Navigator.push(context, MaterialPageRoute(builder: (builder) => 
          ImagePreview(
            image: File(image.path),
            chatroom: widget.chatroom!,
            saveImage: true,
            sendCallback: widget.sendCallback,
          )
        ));
      }
      return; // do nothing for now
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
    }
  }

  // Action of start recording
  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (controller!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  // Action of pause recording
  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Video recording is not in progress
      return;
    }
    try {
      await controller!.pauseVideoRecording();
      setState(() {
        _isRecordingPaused = true;
      });
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  // Action of resume recording
  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // No video recording was in progress
      return;
    }
    try {
      await controller!.resumeVideoRecording();
      setState(() {
        _isRecordingPaused = false;
      });
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  // Action of stop recording
  Future<void> stopVideoRecording(BuildContext context) async {
    if (!(controller!.value.isRecordingVideo)) {
      // Recording is already is stopped state
      return;
    }

    try {
      XFile video = await controller!.stopVideoRecording();
      setState(() {
        _isRecordingInProgress = false;
      });
      if (widget.source == Source.chatroom) {
        Navigator.push(context, MaterialPageRoute(builder: (builder) => 
          VideoPreview(
            video: File(video.path),
            chatroom: widget.chatroom!,
            sendCallback: widget.sendCallback,
          )
        ));
      }
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return;
    }
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
    );
    return _isCameraPermissionGranted
    ? Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<bool>(
        future: _getCameraFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (!_isCameraInitialized) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              )
            );
          }
          return Center(
            child: AspectRatio(
              aspectRatio: 1 / controller!.value.aspectRatio,
              child: Stack(
                children: [
                  Listener(
                    onPointerDown: (_) => _pointers++,
                    onPointerUp: (_) => _pointers--,
                    child: CameraPreview(
                      controller!,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) => onViewFinderTap(details, constraints),
                          onScaleStart: _handleScaleStart,
                          onScaleUpdate: _handleScaleUpdate,
                        );
                      }),
                    ),
                  ),                  
                  Positioned(
                    top: 0.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        // Top items
                        padding: const EdgeInsets.only(top: 18, left: 26, right: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Return
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),

                            const Spacer(),

                            // Flashlight
                            IconButton(
                              onPressed: () async {
                                switch (_currentFlashMode) {
                                  case FlashMode.off:
                                    setState(() {
                                      _currentFlashMode = FlashMode.always;
                                    });
                                    await controller!.setFlashMode(
                                      FlashMode.always,
                                    );
                                    break;
                                  case FlashMode.always:
                                    setState(() {
                                      _currentFlashMode = FlashMode.auto;
                                    });
                                    await controller!.setFlashMode(
                                      FlashMode.auto,
                                    );
                                    break;
                                  case FlashMode.auto:
                                    setState(() {
                                      _currentFlashMode = FlashMode.off;
                                    });
                                    await controller!.setFlashMode(
                                      FlashMode.off,
                                    );
                                    break;
                                  default: print("How?"); break;
                                }
                              },
                              icon: Icon(
                                _currentFlashMode == FlashMode.off 
                                  ? Icons.flash_off
                                  : _currentFlashMode == FlashMode.always
                                    ? Icons.flash_on
                                    : Icons.flash_auto,
                                color: Colors.white,
                                size: 28,
                              ),
                            )
                          ]
                        ),
                      )
                    )
                  ),
                  // Bottom part
                  Positioned(
                    bottom: 0.0,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      color: Colors.black54,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 4),
                              // Recording video ? Pause video : Flip camera
                              _isRecordingInProgress
                              ? IconButton(
                                onPressed: () async {
                                  if (controller!
                                      .value.isRecordingPaused) {
                                    await resumeVideoRecording();
                                  } else {
                                    await pauseVideoRecording();
                                  }
                                },
                                icon: Icon(
                                  _isRecordingPaused ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              )
                              : IconButton(
                                icon: Icon(
                                  Platform.isIOS ? Icons.flip_camera_ios : Icons.flip_camera_android,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _isCameraInitialized = false;
                                    _isRearCameraSelected = !_isRearCameraSelected;
                                  });
                                  onNewCameraSelected(_cameras[_isRearCameraSelected ? 1 : 0]);
                                }
                              ),

                              // Take photo (or record)
                              IconButton(
                                onPressed: _isVideoModeSelected
                                ? () async { // Video
                                  if (_isRecordingInProgress) {
                                    await stopVideoRecording(context);
                                  } else {
                                    await startVideoRecording();
                                  }
                                }
                                : () async { // Photo
                                  await takePicture(context);
                                },
                                icon: Icon(
                                  Icons.radio_button_on,
                                  color: _isRecordingInProgress ? Palette.firebirdRed : Colors.white,
                                ),
                                iconSize: 80,
                              ),

                              // Gallery
                              IconButton(
                                onPressed: () async {
                                  if (!_isRecordingInProgress) {
                                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (image == null) return;
                                    // Redirect to preview screen if from chatroom
                                    // Redirect to cropping if for user/group icon
                                    if (widget.source == Source.chatroom) {
                                      Navigator.push(context, MaterialPageRoute(builder: (builder) => 
                                        ImagePreview(
                                          image: File(image.path),
                                          chatroom: widget.chatroom!,
                                          sendCallback: widget.sendCallback,
                                        )
                                      ));
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.image_search,
                                  color: (_isRecordingInProgress) ? Colors.grey : Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          // Toggle buttons
                          Visibility(
                            visible: widget.source == Source.chatroom,
                            child: ToggleButtons(
                              isSelected: [!_isVideoModeSelected, _isVideoModeSelected],
                              onPressed: (index) {
                                if (index == 0) {
                                  setState(() {
                                    _isVideoModeSelected = false;
                                  });
                                } else {
                                  setState(() {
                                    _isVideoModeSelected = true;
                                  });
                                }
                              },
                              color: Colors.blueGrey,
                              disabledColor: Colors.black,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              children: [
                                Icon(Icons.camera_alt,
                                  color: _isVideoModeSelected ? Colors.grey : Colors.white,
                                  size: 16
                                ),
                                Icon(Icons.videocam,
                                  color: _isVideoModeSelected ? Colors.white : Colors.grey,
                                  size: 16
                                ),
                              ],
                            )
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            )
          );
        }
      ),
    )
    : Material(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Permission denied',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _grantPermission();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Grant permission',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}