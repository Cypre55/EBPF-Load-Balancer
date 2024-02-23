; ModuleID = 'lb.c'
source_filename = "lb.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.dest_info = type { i32, i32, [6 x i8], i16 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@ip_to_key = dso_local global %struct.bpf_map_def { i32 1, i32 4, i32 4, i32 3, i32 0 }, section "maps", align 4
@servers = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 16, i32 3, i32 0 }, section "maps", align 4
@server_cnt = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 2, i32 1, i32 0 }, section "maps", align 4
@queue = dso_local global %struct.bpf_map_def { i32 22, i32 0, i32 8, i32 100, i32 0 }, section "maps", align 4
@__const.load_balancer.____fmt.1 = private unnamed_addr constant [15 x i8] c"[BACKEND] %pI4\00", align 1
@__const.load_balancer.____fmt.3 = private unnamed_addr constant [13 x i8] c"[REGISTERED]\00", align 1
@__const.load_balancer.____fmt.5 = private unnamed_addr constant [11 x i8] c"[COMPLETE]\00", align 1
@__const.load_balancer.____fmt.9 = private unnamed_addr constant [23 x i8] c"[QUEUE] Dequeued: %llu\00", align 1
@__const.load_balancer.____fmt.11 = private unnamed_addr constant [14 x i8] c"[QUEUE] Empty\00", align 1
@__const.load_balancer.____fmt.14 = private unnamed_addr constant [14 x i8] c"[CLIENT] %pI4\00", align 1
@__const.load_balancer.____fmt.16 = private unnamed_addr constant [14 x i8] c"[UNAVAILABLE]\00", align 1
@__const.load_balancer.____fmt.17 = private unnamed_addr constant [23 x i8] c"[QUEUE] Enqueued: %llu\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1
@__const.get_available_backend.____fmt = private unnamed_addr constant [9 x i8] c"[SELECT]\00", align 1
@__const.get_available_backend.____fmt.21 = private unnamed_addr constant [17 x i8] c"Backend %pI4: %d\00", align 1
@__const.get_available_backend.____fmt.22 = private unnamed_addr constant [23 x i8] c"Selected backend: None\00", align 1
@__const.get_available_backend.____fmt.23 = private unnamed_addr constant [23 x i8] c"Selected backend: %pI4\00", align 1
@__const.send_to_backend.____fmt = private unnamed_addr constant [18 x i8] c"Backend not found\00", align 1
@__const.send_to_backend.____fmt.25 = private unnamed_addr constant [12 x i8] c"[SENT] %pI4\00", align 1
@__const.send_to_backend.____fmt.26 = private unnamed_addr constant [37 x i8] c"------------------------------------\00", align 1
@llvm.used = appending global [6 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @ip_to_key to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @load_balancer to i8*), i8* bitcast (%struct.bpf_map_def* @queue to i8*), i8* bitcast (%struct.bpf_map_def* @server_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @servers to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @load_balancer(%struct.xdp_md* %0) #0 section "xdp" {
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca [18 x i8], align 1
  %8 = alloca [1 x i8], align 1
  %9 = alloca [12 x i8], align 1
  %10 = alloca [1 x i8], align 1
  %11 = alloca i64, align 8
  %12 = alloca i32, align 4
  %13 = alloca [9 x i8], align 1
  %14 = alloca i32, align 4
  %15 = alloca [17 x i8], align 1
  %16 = alloca [17 x i8], align 1
  %17 = alloca [17 x i8], align 1
  %18 = alloca [23 x i8], align 1
  %19 = alloca [23 x i8], align 1
  %20 = alloca [37 x i8], align 1
  %21 = alloca i64, align 8
  %22 = alloca [37 x i8], align 1
  %23 = alloca [15 x i8], align 1
  %24 = alloca [37 x i8], align 1
  %25 = alloca i32, align 4
  %26 = alloca i32, align 4
  %27 = alloca i32, align 4
  %28 = alloca i16, align 2
  %29 = alloca [13 x i8], align 1
  %30 = alloca [37 x i8], align 1
  %31 = alloca [1 x i8], align 1
  %32 = alloca %struct.dest_info, align 4
  %33 = alloca i32, align 4
  %34 = alloca [1 x i8], align 1
  %35 = alloca [11 x i8], align 1
  %36 = alloca [37 x i8], align 1
  %37 = alloca [14 x i8], align 1
  %38 = alloca [37 x i8], align 1
  %39 = alloca [1 x i8], align 1
  %40 = alloca [23 x i8], align 1
  %41 = alloca [37 x i8], align 1
  %42 = alloca [14 x i8], align 1
  %43 = alloca [37 x i8], align 1
  %44 = alloca [1 x i8], align 1
  %45 = alloca [37 x i8], align 1
  %46 = alloca [14 x i8], align 1
  %47 = alloca [37 x i8], align 1
  %48 = alloca [14 x i8], align 1
  %49 = alloca [23 x i8], align 1
  %50 = alloca [37 x i8], align 1
  %51 = alloca [1 x i8], align 1
  %52 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %53 = load i32, i32* %52, align 4, !tbaa !2
  %54 = zext i32 %53 to i64
  %55 = inttoptr i64 %54 to i8*
  %56 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %57 = load i32, i32* %56, align 4, !tbaa !7
  %58 = zext i32 %57 to i64
  %59 = inttoptr i64 %58 to i8*
  %60 = inttoptr i64 %54 to %struct.ethhdr*
  %61 = getelementptr i8, i8* %55, i64 14
  %62 = icmp ugt i8* %61, %59
  br i1 %62, label %676, label %63

63:                                               ; preds = %1
  %64 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %60, i64 0, i32 2
  %65 = load i16, i16* %64, align 1, !tbaa !8
  %66 = icmp eq i16 %65, 8
  br i1 %66, label %67, label %676

67:                                               ; preds = %63
  %68 = getelementptr i8, i8* %55, i64 34
  %69 = icmp ugt i8* %68, %59
  br i1 %69, label %676, label %70

70:                                               ; preds = %67
  %71 = getelementptr i8, i8* %55, i64 23
  %72 = load i8, i8* %71, align 1, !tbaa !11
  %73 = icmp eq i8 %72, 17
  br i1 %73, label %74, label %676

74:                                               ; preds = %70
  %75 = getelementptr i8, i8* %55, i64 42
  %76 = icmp ugt i8* %75, %59
  br i1 %76, label %676, label %77

77:                                               ; preds = %74
  %78 = getelementptr i8, i8* %55, i64 36
  %79 = bitcast i8* %78 to i16*
  %80 = load i16, i16* %79, align 2, !tbaa !13
  %81 = icmp eq i16 %80, -28641
  br i1 %81, label %82, label %676

82:                                               ; preds = %77
  %83 = ptrtoint i8* %75 to i64
  %84 = trunc i64 %83 to i32
  %85 = sub i32 %57, %84
  switch i32 %85, label %676 [
    i32 1, label %86
    i32 8, label %435
  ]

86:                                               ; preds = %82
  %87 = getelementptr inbounds [37 x i8], [37 x i8]* %22, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %87) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %87, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %88 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %87, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %87) #3
  %89 = getelementptr inbounds [15 x i8], [15 x i8]* %23, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 15, i8* nonnull %89) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(15) %89, i8* nonnull align 1 dereferenceable(15) getelementptr inbounds ([15 x i8], [15 x i8]* @__const.load_balancer.____fmt.1, i64 0, i64 0), i64 15, i1 false)
  %90 = getelementptr i8, i8* %55, i64 26
  %91 = bitcast i8* %90 to i32*
  %92 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %89, i32 15, i8* %90) #3
  call void @llvm.lifetime.end.p0i8(i64 15, i8* nonnull %89) #3
  %93 = getelementptr inbounds [37 x i8], [37 x i8]* %24, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %93) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %93, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %94 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %93, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %93) #3
  %95 = bitcast i32* %25 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %95) #3
  %96 = load i32, i32* %91, align 4, !tbaa !15
  store i32 %96, i32* %25, align 4, !tbaa !16
  %97 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_to_key to i8*), i8* nonnull %95) #3
  %98 = bitcast i32* %26 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %98) #3
  %99 = icmp eq i8* %97, null
  br i1 %99, label %100, label %116

100:                                              ; preds = %86
  %101 = bitcast i32* %27 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %101) #3
  store i32 0, i32* %27, align 4, !tbaa !16
  %102 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @server_cnt to i8*), i8* nonnull %101) #3
  %103 = icmp eq i8* %102, null
  br i1 %103, label %104, label %109

104:                                              ; preds = %100
  %105 = bitcast i16* %28 to i8*
  call void @llvm.lifetime.start.p0i8(i64 2, i8* nonnull %105) #3
  store i16 0, i16* %28, align 2, !tbaa !17
  %106 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @server_cnt to i8*), i8* nonnull %101, i8* nonnull %105, i64 0) #3
  %107 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @server_cnt to i8*), i8* nonnull %101) #3
  %108 = icmp eq i8* %107, null
  call void @llvm.lifetime.end.p0i8(i64 2, i8* nonnull %105) #3
  br i1 %108, label %115, label %109

109:                                              ; preds = %104, %100
  %110 = phi i8* [ %102, %100 ], [ %107, %104 ]
  %111 = bitcast i8* %110 to i16*
  %112 = load i16, i16* %111, align 2, !tbaa !17
  %113 = zext i16 %112 to i32
  store i32 %113, i32* %26, align 4, !tbaa !16
  %114 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_to_key to i8*), i8* nonnull %95, i8* nonnull %98, i64 0) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %101) #3
  br label %119

115:                                              ; preds = %104
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %101) #3
  br label %433

116:                                              ; preds = %86
  %117 = bitcast i8* %97 to i32*
  %118 = load i32, i32* %117, align 4, !tbaa !16
  store i32 %118, i32* %26, align 4, !tbaa !16
  br label %119

119:                                              ; preds = %109, %116
  %120 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %98) #3
  %121 = icmp eq i8* %120, null
  br i1 %121, label %126, label %122

122:                                              ; preds = %119
  %123 = bitcast i8* %120 to i32*
  %124 = load i32, i32* %123, align 4, !tbaa !18
  %125 = icmp eq i32 %124, 0
  br i1 %125, label %126, label %156

126:                                              ; preds = %119, %122
  %127 = getelementptr inbounds [13 x i8], [13 x i8]* %29, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 13, i8* nonnull %127) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(13) %127, i8* nonnull align 1 dereferenceable(13) getelementptr inbounds ([13 x i8], [13 x i8]* @__const.load_balancer.____fmt.3, i64 0, i64 0), i64 13, i1 false)
  %128 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %127, i32 13) #3
  call void @llvm.lifetime.end.p0i8(i64 13, i8* nonnull %127) #3
  %129 = getelementptr inbounds [37 x i8], [37 x i8]* %30, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %129) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %129, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %130 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %129, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %129) #3
  %131 = getelementptr inbounds [1 x i8], [1 x i8]* %31, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %131) #3
  store i8 0, i8* %131, align 1
  %132 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %131, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %131) #3
  %133 = bitcast %struct.dest_info* %32 to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %133) #3
  %134 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %32, i64 0, i32 0
  %135 = load i32, i32* %91, align 4
  store i32 %135, i32* %134, align 4
  %136 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %32, i64 0, i32 1
  %137 = getelementptr i8, i8* %55, i64 30
  %138 = bitcast i8* %137 to i32*
  %139 = load i32, i32* %138, align 4
  store i32 %139, i32* %136, align 4
  %140 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %32, i64 0, i32 2, i64 0
  %141 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %60, i64 0, i32 1, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(6) %140, i8* nonnull align 1 dereferenceable(6) %141, i64 6, i1 false)
  %142 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %32, i64 0, i32 3
  store i16 5, i16* %142, align 2, !tbaa !20
  %143 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %98, i8* nonnull %133, i64 0) #3
  %144 = bitcast i32* %33 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %144) #3
  store i32 0, i32* %33, align 4, !tbaa !16
  %145 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @server_cnt to i8*), i8* nonnull %144) #3
  %146 = bitcast i8* %145 to i16*
  %147 = icmp eq i8* %145, null
  br i1 %147, label %154, label %148

148:                                              ; preds = %126
  %149 = load i16, i16* %146, align 2, !tbaa !17
  %150 = add i16 %149, 1
  store i16 %150, i16* %146, align 2, !tbaa !17
  %151 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @server_cnt to i8*), i8* nonnull %144, i8* nonnull %145, i64 0) #3
  %152 = getelementptr inbounds [1 x i8], [1 x i8]* %34, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %152) #3
  store i8 0, i8* %152, align 1
  %153 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %152, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %152) #3
  br label %154

154:                                              ; preds = %126, %148
  %155 = phi i32 [ 1, %148 ], [ 0, %126 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %144) #3
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %133) #3
  br label %433

156:                                              ; preds = %122
  %157 = getelementptr inbounds [11 x i8], [11 x i8]* %35, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 11, i8* nonnull %157) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(11) %157, i8* nonnull align 1 dereferenceable(11) getelementptr inbounds ([11 x i8], [11 x i8]* @__const.load_balancer.____fmt.5, i64 0, i64 0), i64 11, i1 false)
  %158 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %157, i32 11) #3
  call void @llvm.lifetime.end.p0i8(i64 11, i8* nonnull %157) #3
  %159 = getelementptr inbounds [37 x i8], [37 x i8]* %36, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %159) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %159, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %160 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %159, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %159) #3
  %161 = getelementptr inbounds i8, i8* %120, i64 14
  %162 = bitcast i8* %161 to i16*
  %163 = load i16, i16* %162, align 2, !tbaa !20
  %164 = add i16 %163, 1
  %165 = icmp ult i16 %164, 5
  %166 = select i1 %165, i16 %164, i16 5
  store i16 %166, i16* %162, align 2, !tbaa !20
  %167 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %98, i8* nonnull %120, i64 0) #3
  %168 = bitcast i64* %21 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %168) #3
  %169 = call i64 inttoptr (i64 89 to i64 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @queue to i8*), i8* nonnull %168) #3
  %170 = icmp eq i64 %169, 0
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %168) #3
  br i1 %170, label %171, label %426

171:                                              ; preds = %156
  %172 = bitcast i32* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %172) #3
  store i32 -1, i32* %12, align 4, !tbaa !16
  %173 = getelementptr inbounds [9 x i8], [9 x i8]* %13, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 9, i8* nonnull %173) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(9) %173, i8* nonnull align 1 dereferenceable(9) getelementptr inbounds ([9 x i8], [9 x i8]* @__const.get_available_backend.____fmt, i64 0, i64 0), i64 9, i1 false) #3
  %174 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %173, i32 9) #3
  call void @llvm.lifetime.end.p0i8(i64 9, i8* nonnull %173) #3
  %175 = bitcast i32* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %175) #3
  store i32 0, i32* %14, align 4, !tbaa !16
  %176 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %175) #3
  %177 = icmp eq i8* %176, null
  br i1 %177, label %193, label %178

178:                                              ; preds = %171
  %179 = bitcast i8* %176 to i32*
  %180 = load i32, i32* %179, align 4, !tbaa !18
  %181 = icmp eq i32 %180, 0
  br i1 %181, label %193, label %182

182:                                              ; preds = %178
  %183 = getelementptr inbounds [17 x i8], [17 x i8]* %15, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %183) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(17) %183, i8* nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.get_available_backend.____fmt.21, i64 0, i64 0), i64 17, i1 false) #3
  %184 = getelementptr inbounds i8, i8* %176, i64 14
  %185 = bitcast i8* %184 to i16*
  %186 = load i16, i16* %185, align 2, !tbaa !20
  %187 = zext i16 %186 to i32
  %188 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %183, i32 17, i8* nonnull %176, i32 %187) #3
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %183) #3
  %189 = load i16, i16* %185, align 2, !tbaa !20
  %190 = icmp eq i16 %189, 0
  br i1 %190, label %193, label %191

191:                                              ; preds = %182
  %192 = load i32, i32* %14, align 4, !tbaa !16
  store i32 %192, i32* %12, align 4, !tbaa !16
  br label %193

193:                                              ; preds = %191, %182, %178, %171
  %194 = phi i16 [ %189, %191 ], [ 0, %182 ], [ 0, %178 ], [ 0, %171 ]
  store i32 1, i32* %14, align 4, !tbaa !16
  %195 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %175) #3
  %196 = icmp eq i8* %195, null
  br i1 %196, label %212, label %197

197:                                              ; preds = %193
  %198 = bitcast i8* %195 to i32*
  %199 = load i32, i32* %198, align 4, !tbaa !18
  %200 = icmp eq i32 %199, 0
  br i1 %200, label %212, label %201

201:                                              ; preds = %197
  %202 = getelementptr inbounds [17 x i8], [17 x i8]* %16, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %202) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(17) %202, i8* nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.get_available_backend.____fmt.21, i64 0, i64 0), i64 17, i1 false) #3
  %203 = getelementptr inbounds i8, i8* %195, i64 14
  %204 = bitcast i8* %203 to i16*
  %205 = load i16, i16* %204, align 2, !tbaa !20
  %206 = zext i16 %205 to i32
  %207 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %202, i32 17, i8* nonnull %195, i32 %206) #3
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %202) #3
  %208 = load i16, i16* %204, align 2, !tbaa !20
  %209 = icmp ugt i16 %208, %194
  br i1 %209, label %210, label %212

210:                                              ; preds = %201
  %211 = load i32, i32* %14, align 4, !tbaa !16
  store i32 %211, i32* %12, align 4, !tbaa !16
  br label %212

212:                                              ; preds = %210, %201, %197, %193
  %213 = phi i16 [ %208, %210 ], [ %194, %201 ], [ %194, %197 ], [ %194, %193 ]
  store i32 2, i32* %14, align 4, !tbaa !16
  %214 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %175) #3
  %215 = icmp eq i8* %214, null
  br i1 %215, label %231, label %216

216:                                              ; preds = %212
  %217 = bitcast i8* %214 to i32*
  %218 = load i32, i32* %217, align 4, !tbaa !18
  %219 = icmp eq i32 %218, 0
  br i1 %219, label %231, label %220

220:                                              ; preds = %216
  %221 = getelementptr inbounds [17 x i8], [17 x i8]* %17, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %221) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(17) %221, i8* nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.get_available_backend.____fmt.21, i64 0, i64 0), i64 17, i1 false) #3
  %222 = getelementptr inbounds i8, i8* %214, i64 14
  %223 = bitcast i8* %222 to i16*
  %224 = load i16, i16* %223, align 2, !tbaa !20
  %225 = zext i16 %224 to i32
  %226 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %221, i32 17, i8* nonnull %214, i32 %225) #3
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %221) #3
  %227 = load i16, i16* %223, align 2, !tbaa !20
  %228 = icmp ugt i16 %227, %213
  br i1 %228, label %229, label %231

229:                                              ; preds = %220
  %230 = load i32, i32* %14, align 4, !tbaa !16
  store i32 %230, i32* %12, align 4, !tbaa !16
  br label %233

231:                                              ; preds = %220, %216, %212
  %232 = load i32, i32* %12, align 4, !tbaa !16
  br label %233

233:                                              ; preds = %231, %229
  %234 = phi i32 [ %232, %231 ], [ %230, %229 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %175) #3
  %235 = icmp eq i32 %234, -1
  br i1 %235, label %236, label %239

236:                                              ; preds = %233
  %237 = getelementptr inbounds [23 x i8], [23 x i8]* %18, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %237) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(23) %237, i8* nonnull align 1 dereferenceable(23) getelementptr inbounds ([23 x i8], [23 x i8]* @__const.get_available_backend.____fmt.22, i64 0, i64 0), i64 23, i1 false) #3
  %238 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %237, i32 23) #3
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %237) #3
  br label %246

239:                                              ; preds = %233
  %240 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %172) #3
  %241 = icmp eq i8* %240, null
  br i1 %241, label %242, label %243

242:                                              ; preds = %239
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %172) #3
  br label %258

243:                                              ; preds = %239
  %244 = getelementptr inbounds [23 x i8], [23 x i8]* %19, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %244) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(23) %244, i8* nonnull align 1 dereferenceable(23) getelementptr inbounds ([23 x i8], [23 x i8]* @__const.get_available_backend.____fmt.23, i64 0, i64 0), i64 23, i1 false) #3
  %245 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %244, i32 23, i8* nonnull %240) #3
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %244) #3
  br label %246

246:                                              ; preds = %236, %243
  %247 = getelementptr inbounds [37 x i8], [37 x i8]* %20, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %247) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %247, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false) #3
  %248 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %247, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %247) #3
  %249 = load i32, i32* %12, align 4, !tbaa !16
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %172) #3
  %250 = icmp eq i32 %249, -1
  br i1 %250, label %251, label %258

251:                                              ; preds = %246
  %252 = getelementptr inbounds [14 x i8], [14 x i8]* %37, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %252) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(14) %252, i8* nonnull align 1 dereferenceable(14) getelementptr inbounds ([14 x i8], [14 x i8]* @__const.load_balancer.____fmt.16, i64 0, i64 0), i64 14, i1 false)
  %253 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %252, i32 14) #3
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %252) #3
  %254 = getelementptr inbounds [37 x i8], [37 x i8]* %38, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %254) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %254, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %255 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %254, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %254) #3
  %256 = getelementptr inbounds [1 x i8], [1 x i8]* %39, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %256) #3
  store i8 0, i8* %256, align 1
  %257 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %256, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %256) #3
  br label %433

258:                                              ; preds = %242, %246
  %259 = phi i32 [ 0, %242 ], [ %249, %246 ]
  %260 = call i64 inttoptr (i64 65 to i64 (%struct.xdp_md*, i32)*)(%struct.xdp_md* nonnull %0, i32 7) #3
  %261 = load i32, i32* %52, align 4, !tbaa !2
  %262 = zext i32 %261 to i64
  %263 = inttoptr i64 %262 to i8*
  %264 = load i32, i32* %56, align 4, !tbaa !7
  %265 = zext i32 %264 to i64
  %266 = inttoptr i64 %265 to i8*
  %267 = inttoptr i64 %262 to %struct.ethhdr*
  %268 = getelementptr i8, i8* %263, i64 14
  %269 = icmp ugt i8* %268, %266
  br i1 %269, label %433, label %270

270:                                              ; preds = %258
  %271 = getelementptr i8, i8* %263, i64 34
  %272 = icmp ugt i8* %271, %266
  br i1 %272, label %433, label %273

273:                                              ; preds = %270
  %274 = getelementptr i8, i8* %263, i64 42
  %275 = icmp ugt i8* %274, %266
  br i1 %275, label %433, label %276

276:                                              ; preds = %273
  %277 = bitcast i64* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %277) #3
  %278 = call i64 inttoptr (i64 88 to i64 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @queue to i8*), i8* nonnull %277) #3
  %279 = load i64, i64* %11, align 8, !tbaa !21
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %277) #3
  %280 = getelementptr i8, i8* %263, i64 50
  %281 = icmp ugt i8* %280, %266
  br i1 %281, label %433, label %282

282:                                              ; preds = %276
  %283 = bitcast i8* %274 to i64*
  store i64 %279, i64* %283, align 1
  %284 = getelementptr inbounds [23 x i8], [23 x i8]* %40, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %284) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(23) %284, i8* nonnull align 1 dereferenceable(23) getelementptr inbounds ([23 x i8], [23 x i8]* @__const.load_balancer.____fmt.9, i64 0, i64 0), i64 23, i1 false)
  %285 = call i64 @llvm.bswap.i64(i64 %279)
  %286 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %284, i32 23, i64 %285) #3
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %284) #3
  %287 = getelementptr inbounds [37 x i8], [37 x i8]* %41, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %287) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %287, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %288 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %287, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %287) #3
  %289 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %289)
  store i32 %259, i32* %6, align 4, !tbaa !16
  %290 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %289) #3
  %291 = icmp eq i8* %290, null
  br i1 %291, label %292, label %297

292:                                              ; preds = %282
  %293 = getelementptr inbounds [18 x i8], [18 x i8]* %7, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 18, i8* nonnull %293) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(18) %293, i8* nonnull align 1 dereferenceable(18) getelementptr inbounds ([18 x i8], [18 x i8]* @__const.send_to_backend.____fmt, i64 0, i64 0), i64 18, i1 false) #3
  %294 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %293, i32 18) #3
  call void @llvm.lifetime.end.p0i8(i64 18, i8* nonnull %293) #3
  %295 = getelementptr inbounds [1 x i8], [1 x i8]* %8, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %295) #3
  store i8 0, i8* %295, align 1
  %296 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %295, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %295) #3
  br label %424

297:                                              ; preds = %282
  %298 = getelementptr inbounds i8, i8* %290, i64 14
  %299 = bitcast i8* %298 to i16*
  %300 = load i16, i16* %299, align 2, !tbaa !20
  %301 = add i16 %300, -1
  store i16 %301, i16* %299, align 2, !tbaa !20
  %302 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %289, i8* nonnull %290, i64 0) #3
  %303 = getelementptr inbounds i8, i8* %290, i64 4
  %304 = bitcast i8* %303 to i32*
  %305 = load i32, i32* %304, align 4, !tbaa !23
  %306 = getelementptr i8, i8* %263, i64 26
  %307 = bitcast i8* %306 to i32*
  store i32 %305, i32* %307, align 4, !tbaa !15
  %308 = bitcast i8* %290 to i32*
  %309 = load i32, i32* %308, align 4, !tbaa !18
  %310 = getelementptr i8, i8* %263, i64 30
  %311 = bitcast i8* %310 to i32*
  store i32 %309, i32* %311, align 4, !tbaa !24
  %312 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %267, i64 0, i32 1, i64 0
  %313 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %267, i64 0, i32 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %312, i8* nonnull align 1 dereferenceable(6) %313, i64 6, i1 false) #3
  %314 = getelementptr inbounds i8, i8* %290, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %313, i8* nonnull align 4 dereferenceable(6) %314, i64 6, i1 false) #3
  %315 = ptrtoint i8* %268 to i64
  %316 = sub i64 %265, %315
  %317 = trunc i64 %316 to i16
  %318 = call i16 @llvm.bswap.i16(i16 %317) #3
  %319 = getelementptr i8, i8* %263, i64 16
  %320 = bitcast i8* %319 to i16*
  store i16 %318, i16* %320, align 2, !tbaa !25
  %321 = ptrtoint i8* %271 to i64
  %322 = sub i64 %265, %321
  %323 = trunc i64 %322 to i16
  %324 = call i16 @llvm.bswap.i16(i16 %323) #3
  %325 = getelementptr i8, i8* %263, i64 38
  %326 = bitcast i8* %325 to i16*
  store i16 %324, i16* %326, align 2, !tbaa !26
  %327 = getelementptr i8, i8* %263, i64 24
  %328 = bitcast i8* %327 to i16*
  %329 = bitcast i8* %268 to i16*
  %330 = load i16, i16* %329, align 2, !tbaa !17
  %331 = zext i16 %330 to i64
  %332 = zext i16 %318 to i64
  %333 = add nuw nsw i64 %331, %332
  %334 = getelementptr i8, i8* %263, i64 18
  %335 = bitcast i8* %334 to i16*
  %336 = load i16, i16* %335, align 2, !tbaa !17
  %337 = zext i16 %336 to i64
  %338 = add nuw nsw i64 %333, %337
  %339 = getelementptr i8, i8* %263, i64 20
  %340 = bitcast i8* %339 to i16*
  %341 = load i16, i16* %340, align 2, !tbaa !17
  %342 = zext i16 %341 to i64
  %343 = add nuw nsw i64 %338, %342
  %344 = getelementptr i8, i8* %263, i64 22
  %345 = bitcast i8* %344 to i16*
  %346 = load i16, i16* %345, align 2, !tbaa !17
  %347 = zext i16 %346 to i64
  %348 = add nuw nsw i64 %343, %347
  %349 = bitcast i8* %306 to i16*
  %350 = load i16, i16* %349, align 2, !tbaa !17
  %351 = zext i16 %350 to i64
  %352 = add nuw nsw i64 %348, %351
  %353 = getelementptr i8, i8* %263, i64 28
  %354 = bitcast i8* %353 to i16*
  %355 = load i16, i16* %354, align 2, !tbaa !17
  %356 = zext i16 %355 to i64
  %357 = add nuw nsw i64 %352, %356
  %358 = bitcast i8* %310 to i16*
  %359 = load i16, i16* %358, align 2, !tbaa !17
  %360 = zext i16 %359 to i64
  %361 = add nuw nsw i64 %357, %360
  %362 = getelementptr i8, i8* %263, i64 32
  %363 = bitcast i8* %362 to i16*
  %364 = load i16, i16* %363, align 2, !tbaa !17
  %365 = zext i16 %364 to i64
  %366 = add nuw nsw i64 %361, %365
  %367 = and i64 %366, 65535
  %368 = lshr i64 %366, 16
  %369 = add nuw nsw i64 %367, %368
  %370 = lshr i64 %369, 16
  %371 = add nuw nsw i64 %370, %369
  %372 = trunc i64 %371 to i16
  %373 = xor i16 %372, -1
  store i16 %373, i16* %328, align 2, !tbaa !27
  %374 = getelementptr i8, i8* %263, i64 40
  %375 = bitcast i8* %374 to i16*
  store i16 0, i16* %375, align 2, !tbaa !28
  %376 = bitcast i8* %271 to i16*
  %377 = load i32, i32* %307, align 4, !tbaa !15
  %378 = lshr i32 %377, 16
  %379 = add i32 %378, %377
  %380 = load i32, i32* %311, align 4, !tbaa !24
  %381 = add i32 %379, %380
  %382 = lshr i32 %380, 16
  %383 = add i32 %381, %382
  %384 = getelementptr i8, i8* %263, i64 23
  %385 = load i8, i8* %384, align 1, !tbaa !11
  %386 = zext i8 %385 to i32
  %387 = shl nuw nsw i32 %386, 8
  %388 = add i32 %383, %387
  %389 = trunc i32 %388 to i16
  %390 = add i16 %324, %389
  %391 = getelementptr i8, i8* %263, i64 1514
  %392 = bitcast i8* %391 to i16*
  br label %393

393:                                              ; preds = %400, %297
  %394 = phi i32 [ 0, %297 ], [ %403, %400 ]
  %395 = phi i16* [ %376, %297 ], [ %397, %400 ]
  %396 = phi i16 [ %390, %297 ], [ %402, %400 ]
  %397 = getelementptr inbounds i16, i16* %395, i64 1
  %398 = bitcast i16* %397 to i8*
  %399 = icmp ugt i8* %398, %266
  br i1 %399, label %405, label %400

400:                                              ; preds = %393
  %401 = load i16, i16* %395, align 2, !tbaa !17
  %402 = add i16 %401, %396
  %403 = add nuw nsw i32 %394, 2
  %404 = icmp ult i32 %394, 1478
  br i1 %404, label %393, label %405

405:                                              ; preds = %400, %393
  %406 = phi i16 [ %396, %393 ], [ %402, %400 ]
  %407 = phi i16* [ %395, %393 ], [ %392, %400 ]
  %408 = bitcast i16* %407 to i8*
  %409 = getelementptr i8, i8* %408, i64 1
  %410 = icmp ugt i8* %409, %266
  br i1 %410, label %415, label %411

411:                                              ; preds = %405
  %412 = load i8, i8* %408, align 1, !tbaa !29
  %413 = zext i8 %412 to i16
  %414 = add i16 %406, %413
  br label %415

415:                                              ; preds = %411, %405
  %416 = phi i16 [ %414, %411 ], [ %406, %405 ]
  %417 = xor i16 %416, -1
  store i16 %417, i16* %375, align 2, !tbaa !28
  %418 = getelementptr inbounds [12 x i8], [12 x i8]* %9, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %418) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(12) %418, i8* nonnull align 1 dereferenceable(12) getelementptr inbounds ([12 x i8], [12 x i8]* @__const.send_to_backend.____fmt.25, i64 0, i64 0), i64 12, i1 false) #3
  %419 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %418, i32 12, i8* nonnull %310) #3
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %418) #3
  %420 = getelementptr inbounds [37 x i8], [37 x i8]* %20, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %420) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %420, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false) #3
  %421 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %420, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %420) #3
  %422 = getelementptr inbounds [1 x i8], [1 x i8]* %10, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %422) #3
  store i8 0, i8* %422, align 1
  %423 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %422, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %422) #3
  br label %424

424:                                              ; preds = %292, %415
  %425 = phi i32 [ 3, %415 ], [ 0, %292 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %289)
  br label %433

426:                                              ; preds = %156
  %427 = getelementptr inbounds [14 x i8], [14 x i8]* %42, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %427) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(14) %427, i8* nonnull align 1 dereferenceable(14) getelementptr inbounds ([14 x i8], [14 x i8]* @__const.load_balancer.____fmt.11, i64 0, i64 0), i64 14, i1 false)
  %428 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %427, i32 14) #3
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %427) #3
  %429 = getelementptr inbounds [37 x i8], [37 x i8]* %43, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %429) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %429, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %430 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %429, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %429) #3
  %431 = getelementptr inbounds [1 x i8], [1 x i8]* %44, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %431) #3
  store i8 0, i8* %431, align 1
  %432 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %431, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %431) #3
  br label %433

433:                                              ; preds = %115, %154, %426, %424, %276, %273, %270, %258, %251
  %434 = phi i32 [ 0, %115 ], [ %155, %154 ], [ 1, %426 ], [ 0, %251 ], [ 0, %258 ], [ 0, %270 ], [ 0, %273 ], [ %425, %424 ], [ 0, %276 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %98) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %95) #3
  br label %676

435:                                              ; preds = %82
  %436 = getelementptr inbounds [37 x i8], [37 x i8]* %45, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %436) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %436, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %437 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %436, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %436) #3
  %438 = getelementptr inbounds [14 x i8], [14 x i8]* %46, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %438) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(14) %438, i8* nonnull align 1 dereferenceable(14) getelementptr inbounds ([14 x i8], [14 x i8]* @__const.load_balancer.____fmt.14, i64 0, i64 0), i64 14, i1 false)
  %439 = getelementptr i8, i8* %55, i64 26
  %440 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %438, i32 14, i8* %439) #3
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %438) #3
  %441 = getelementptr inbounds [37 x i8], [37 x i8]* %47, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %441) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %441, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %442 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %441, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %441) #3
  %443 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %443) #3
  store i32 -1, i32* %4, align 4, !tbaa !16
  %444 = getelementptr inbounds [9 x i8], [9 x i8]* %13, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 9, i8* nonnull %444) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(9) %444, i8* nonnull align 1 dereferenceable(9) getelementptr inbounds ([9 x i8], [9 x i8]* @__const.get_available_backend.____fmt, i64 0, i64 0), i64 9, i1 false) #3
  %445 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %444, i32 9) #3
  call void @llvm.lifetime.end.p0i8(i64 9, i8* nonnull %444) #3
  %446 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %446) #3
  store i32 0, i32* %5, align 4, !tbaa !16
  %447 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %446) #3
  %448 = icmp eq i8* %447, null
  br i1 %448, label %464, label %449

449:                                              ; preds = %435
  %450 = bitcast i8* %447 to i32*
  %451 = load i32, i32* %450, align 4, !tbaa !18
  %452 = icmp eq i32 %451, 0
  br i1 %452, label %464, label %453

453:                                              ; preds = %449
  %454 = getelementptr inbounds [17 x i8], [17 x i8]* %15, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %454) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(17) %454, i8* nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.get_available_backend.____fmt.21, i64 0, i64 0), i64 17, i1 false) #3
  %455 = getelementptr inbounds i8, i8* %447, i64 14
  %456 = bitcast i8* %455 to i16*
  %457 = load i16, i16* %456, align 2, !tbaa !20
  %458 = zext i16 %457 to i32
  %459 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %454, i32 17, i8* nonnull %447, i32 %458) #3
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %454) #3
  %460 = load i16, i16* %456, align 2, !tbaa !20
  %461 = icmp eq i16 %460, 0
  br i1 %461, label %464, label %462

462:                                              ; preds = %453
  %463 = load i32, i32* %5, align 4, !tbaa !16
  store i32 %463, i32* %4, align 4, !tbaa !16
  br label %464

464:                                              ; preds = %462, %453, %449, %435
  %465 = phi i16 [ %460, %462 ], [ 0, %453 ], [ 0, %449 ], [ 0, %435 ]
  store i32 1, i32* %5, align 4, !tbaa !16
  %466 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %446) #3
  %467 = icmp eq i8* %466, null
  br i1 %467, label %483, label %468

468:                                              ; preds = %464
  %469 = bitcast i8* %466 to i32*
  %470 = load i32, i32* %469, align 4, !tbaa !18
  %471 = icmp eq i32 %470, 0
  br i1 %471, label %483, label %472

472:                                              ; preds = %468
  %473 = getelementptr inbounds [17 x i8], [17 x i8]* %16, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %473) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(17) %473, i8* nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.get_available_backend.____fmt.21, i64 0, i64 0), i64 17, i1 false) #3
  %474 = getelementptr inbounds i8, i8* %466, i64 14
  %475 = bitcast i8* %474 to i16*
  %476 = load i16, i16* %475, align 2, !tbaa !20
  %477 = zext i16 %476 to i32
  %478 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %473, i32 17, i8* nonnull %466, i32 %477) #3
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %473) #3
  %479 = load i16, i16* %475, align 2, !tbaa !20
  %480 = icmp ugt i16 %479, %465
  br i1 %480, label %481, label %483

481:                                              ; preds = %472
  %482 = load i32, i32* %5, align 4, !tbaa !16
  store i32 %482, i32* %4, align 4, !tbaa !16
  br label %483

483:                                              ; preds = %481, %472, %468, %464
  %484 = phi i16 [ %479, %481 ], [ %465, %472 ], [ %465, %468 ], [ %465, %464 ]
  store i32 2, i32* %5, align 4, !tbaa !16
  %485 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %446) #3
  %486 = icmp eq i8* %485, null
  br i1 %486, label %502, label %487

487:                                              ; preds = %483
  %488 = bitcast i8* %485 to i32*
  %489 = load i32, i32* %488, align 4, !tbaa !18
  %490 = icmp eq i32 %489, 0
  br i1 %490, label %502, label %491

491:                                              ; preds = %487
  %492 = getelementptr inbounds [17 x i8], [17 x i8]* %17, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 17, i8* nonnull %492) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(17) %492, i8* nonnull align 1 dereferenceable(17) getelementptr inbounds ([17 x i8], [17 x i8]* @__const.get_available_backend.____fmt.21, i64 0, i64 0), i64 17, i1 false) #3
  %493 = getelementptr inbounds i8, i8* %485, i64 14
  %494 = bitcast i8* %493 to i16*
  %495 = load i16, i16* %494, align 2, !tbaa !20
  %496 = zext i16 %495 to i32
  %497 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %492, i32 17, i8* nonnull %485, i32 %496) #3
  call void @llvm.lifetime.end.p0i8(i64 17, i8* nonnull %492) #3
  %498 = load i16, i16* %494, align 2, !tbaa !20
  %499 = icmp ugt i16 %498, %484
  br i1 %499, label %500, label %502

500:                                              ; preds = %491
  %501 = load i32, i32* %5, align 4, !tbaa !16
  store i32 %501, i32* %4, align 4, !tbaa !16
  br label %504

502:                                              ; preds = %491, %487, %483
  %503 = load i32, i32* %4, align 4, !tbaa !16
  br label %504

504:                                              ; preds = %502, %500
  %505 = phi i32 [ %503, %502 ], [ %501, %500 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %446) #3
  %506 = icmp eq i32 %505, -1
  br i1 %506, label %507, label %510

507:                                              ; preds = %504
  %508 = getelementptr inbounds [23 x i8], [23 x i8]* %18, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %508) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(23) %508, i8* nonnull align 1 dereferenceable(23) getelementptr inbounds ([23 x i8], [23 x i8]* @__const.get_available_backend.____fmt.22, i64 0, i64 0), i64 23, i1 false) #3
  %509 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %508, i32 23) #3
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %508) #3
  br label %517

510:                                              ; preds = %504
  %511 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #3
  %512 = icmp eq i8* %511, null
  br i1 %512, label %513, label %514

513:                                              ; preds = %510
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %443) #3
  br label %539

514:                                              ; preds = %510
  %515 = getelementptr inbounds [23 x i8], [23 x i8]* %19, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %515) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(23) %515, i8* nonnull align 1 dereferenceable(23) getelementptr inbounds ([23 x i8], [23 x i8]* @__const.get_available_backend.____fmt.23, i64 0, i64 0), i64 23, i1 false) #3
  %516 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %515, i32 23, i8* nonnull %511) #3
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %515) #3
  br label %517

517:                                              ; preds = %507, %514
  %518 = getelementptr inbounds [37 x i8], [37 x i8]* %20, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %518) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %518, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false) #3
  %519 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %518, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %518) #3
  %520 = load i32, i32* %4, align 4, !tbaa !16
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %443) #3
  %521 = icmp eq i32 %520, -1
  br i1 %521, label %522, label %539

522:                                              ; preds = %517
  %523 = getelementptr inbounds [14 x i8], [14 x i8]* %48, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %523) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(14) %523, i8* nonnull align 1 dereferenceable(14) getelementptr inbounds ([14 x i8], [14 x i8]* @__const.load_balancer.____fmt.16, i64 0, i64 0), i64 14, i1 false)
  %524 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %523, i32 14) #3
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %523) #3
  %525 = getelementptr i8, i8* %55, i64 50
  %526 = icmp ugt i8* %525, %59
  br i1 %526, label %676, label %527

527:                                              ; preds = %522
  %528 = bitcast i8* %75 to i64*
  %529 = load i64, i64* %528, align 1
  %530 = bitcast i64* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %530)
  store i64 %529, i64* %3, align 8, !tbaa !21
  %531 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @queue to i8*), i8* nonnull %530, i64 0) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %530)
  %532 = getelementptr inbounds [23 x i8], [23 x i8]* %49, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %532) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(23) %532, i8* nonnull align 1 dereferenceable(23) getelementptr inbounds ([23 x i8], [23 x i8]* @__const.load_balancer.____fmt.17, i64 0, i64 0), i64 23, i1 false)
  %533 = call i64 @llvm.bswap.i64(i64 %529)
  %534 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %532, i32 23, i64 %533) #3
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %532) #3
  %535 = getelementptr inbounds [37 x i8], [37 x i8]* %50, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %535) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %535, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false)
  %536 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %535, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %535) #3
  %537 = getelementptr inbounds [1 x i8], [1 x i8]* %51, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %537) #3
  store i8 0, i8* %537, align 1
  %538 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %537, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %537) #3
  br label %676

539:                                              ; preds = %513, %517
  %540 = phi i32 [ 0, %513 ], [ %520, %517 ]
  %541 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %541)
  store i32 %540, i32* %2, align 4, !tbaa !16
  %542 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %541) #3
  %543 = icmp eq i8* %542, null
  br i1 %543, label %544, label %549

544:                                              ; preds = %539
  %545 = getelementptr inbounds [18 x i8], [18 x i8]* %7, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 18, i8* nonnull %545) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(18) %545, i8* nonnull align 1 dereferenceable(18) getelementptr inbounds ([18 x i8], [18 x i8]* @__const.send_to_backend.____fmt, i64 0, i64 0), i64 18, i1 false) #3
  %546 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %545, i32 18) #3
  call void @llvm.lifetime.end.p0i8(i64 18, i8* nonnull %545) #3
  %547 = getelementptr inbounds [1 x i8], [1 x i8]* %8, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %547) #3
  store i8 0, i8* %547, align 1
  %548 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %547, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %547) #3
  br label %674

549:                                              ; preds = %539
  %550 = getelementptr inbounds i8, i8* %542, i64 14
  %551 = bitcast i8* %550 to i16*
  %552 = load i16, i16* %551, align 2, !tbaa !20
  %553 = add i16 %552, -1
  store i16 %553, i16* %551, align 2, !tbaa !20
  %554 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %541, i8* nonnull %542, i64 0) #3
  %555 = getelementptr inbounds i8, i8* %542, i64 4
  %556 = bitcast i8* %555 to i32*
  %557 = load i32, i32* %556, align 4, !tbaa !23
  %558 = bitcast i8* %439 to i32*
  store i32 %557, i32* %558, align 4, !tbaa !15
  %559 = bitcast i8* %542 to i32*
  %560 = load i32, i32* %559, align 4, !tbaa !18
  %561 = getelementptr i8, i8* %55, i64 30
  %562 = bitcast i8* %561 to i32*
  store i32 %560, i32* %562, align 4, !tbaa !24
  %563 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %60, i64 0, i32 1, i64 0
  %564 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %60, i64 0, i32 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %563, i8* nonnull align 1 dereferenceable(6) %564, i64 6, i1 false) #3
  %565 = getelementptr inbounds i8, i8* %542, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %564, i8* nonnull align 4 dereferenceable(6) %565, i64 6, i1 false) #3
  %566 = ptrtoint i8* %61 to i64
  %567 = sub i64 %58, %566
  %568 = trunc i64 %567 to i16
  %569 = call i16 @llvm.bswap.i16(i16 %568) #3
  %570 = getelementptr i8, i8* %55, i64 16
  %571 = bitcast i8* %570 to i16*
  store i16 %569, i16* %571, align 2, !tbaa !25
  %572 = ptrtoint i8* %68 to i64
  %573 = sub i64 %58, %572
  %574 = trunc i64 %573 to i16
  %575 = call i16 @llvm.bswap.i16(i16 %574) #3
  %576 = getelementptr i8, i8* %55, i64 38
  %577 = bitcast i8* %576 to i16*
  store i16 %575, i16* %577, align 2, !tbaa !26
  %578 = getelementptr i8, i8* %55, i64 24
  %579 = bitcast i8* %578 to i16*
  %580 = bitcast i8* %61 to i16*
  %581 = load i16, i16* %580, align 2, !tbaa !17
  %582 = zext i16 %581 to i64
  %583 = zext i16 %569 to i64
  %584 = add nuw nsw i64 %582, %583
  %585 = getelementptr i8, i8* %55, i64 18
  %586 = bitcast i8* %585 to i16*
  %587 = load i16, i16* %586, align 2, !tbaa !17
  %588 = zext i16 %587 to i64
  %589 = add nuw nsw i64 %584, %588
  %590 = getelementptr i8, i8* %55, i64 20
  %591 = bitcast i8* %590 to i16*
  %592 = load i16, i16* %591, align 2, !tbaa !17
  %593 = zext i16 %592 to i64
  %594 = add nuw nsw i64 %589, %593
  %595 = getelementptr i8, i8* %55, i64 22
  %596 = bitcast i8* %595 to i16*
  %597 = load i16, i16* %596, align 2, !tbaa !17
  %598 = zext i16 %597 to i64
  %599 = add nuw nsw i64 %594, %598
  %600 = bitcast i8* %439 to i16*
  %601 = load i16, i16* %600, align 2, !tbaa !17
  %602 = zext i16 %601 to i64
  %603 = add nuw nsw i64 %599, %602
  %604 = getelementptr i8, i8* %55, i64 28
  %605 = bitcast i8* %604 to i16*
  %606 = load i16, i16* %605, align 2, !tbaa !17
  %607 = zext i16 %606 to i64
  %608 = add nuw nsw i64 %603, %607
  %609 = bitcast i8* %561 to i16*
  %610 = load i16, i16* %609, align 2, !tbaa !17
  %611 = zext i16 %610 to i64
  %612 = add nuw nsw i64 %608, %611
  %613 = getelementptr i8, i8* %55, i64 32
  %614 = bitcast i8* %613 to i16*
  %615 = load i16, i16* %614, align 2, !tbaa !17
  %616 = zext i16 %615 to i64
  %617 = add nuw nsw i64 %612, %616
  %618 = and i64 %617, 65535
  %619 = lshr i64 %617, 16
  %620 = add nuw nsw i64 %618, %619
  %621 = lshr i64 %620, 16
  %622 = add nuw nsw i64 %621, %620
  %623 = trunc i64 %622 to i16
  %624 = xor i16 %623, -1
  store i16 %624, i16* %579, align 2, !tbaa !27
  %625 = getelementptr i8, i8* %55, i64 40
  %626 = bitcast i8* %625 to i16*
  store i16 0, i16* %626, align 2, !tbaa !28
  %627 = bitcast i8* %68 to i16*
  %628 = load i32, i32* %558, align 4, !tbaa !15
  %629 = lshr i32 %628, 16
  %630 = add i32 %629, %628
  %631 = load i32, i32* %562, align 4, !tbaa !24
  %632 = add i32 %630, %631
  %633 = lshr i32 %631, 16
  %634 = add i32 %632, %633
  %635 = load i8, i8* %71, align 1, !tbaa !11
  %636 = zext i8 %635 to i32
  %637 = shl nuw nsw i32 %636, 8
  %638 = add i32 %634, %637
  %639 = trunc i32 %638 to i16
  %640 = add i16 %575, %639
  %641 = getelementptr i8, i8* %55, i64 1514
  %642 = bitcast i8* %641 to i16*
  br label %643

643:                                              ; preds = %650, %549
  %644 = phi i32 [ 0, %549 ], [ %653, %650 ]
  %645 = phi i16* [ %627, %549 ], [ %647, %650 ]
  %646 = phi i16 [ %640, %549 ], [ %652, %650 ]
  %647 = getelementptr inbounds i16, i16* %645, i64 1
  %648 = bitcast i16* %647 to i8*
  %649 = icmp ugt i8* %648, %59
  br i1 %649, label %655, label %650

650:                                              ; preds = %643
  %651 = load i16, i16* %645, align 2, !tbaa !17
  %652 = add i16 %651, %646
  %653 = add nuw nsw i32 %644, 2
  %654 = icmp ult i32 %644, 1478
  br i1 %654, label %643, label %655

655:                                              ; preds = %650, %643
  %656 = phi i16 [ %646, %643 ], [ %652, %650 ]
  %657 = phi i16* [ %645, %643 ], [ %642, %650 ]
  %658 = bitcast i16* %657 to i8*
  %659 = getelementptr i8, i8* %658, i64 1
  %660 = icmp ugt i8* %659, %59
  br i1 %660, label %665, label %661

661:                                              ; preds = %655
  %662 = load i8, i8* %658, align 1, !tbaa !29
  %663 = zext i8 %662 to i16
  %664 = add i16 %656, %663
  br label %665

665:                                              ; preds = %661, %655
  %666 = phi i16 [ %664, %661 ], [ %656, %655 ]
  %667 = xor i16 %666, -1
  store i16 %667, i16* %626, align 2, !tbaa !28
  %668 = getelementptr inbounds [12 x i8], [12 x i8]* %9, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %668) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(12) %668, i8* nonnull align 1 dereferenceable(12) getelementptr inbounds ([12 x i8], [12 x i8]* @__const.send_to_backend.____fmt.25, i64 0, i64 0), i64 12, i1 false) #3
  %669 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %668, i32 12, i8* nonnull %561) #3
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %668) #3
  %670 = getelementptr inbounds [37 x i8], [37 x i8]* %20, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %670) #3
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(37) %670, i8* nonnull align 1 dereferenceable(37) getelementptr inbounds ([37 x i8], [37 x i8]* @__const.send_to_backend.____fmt.26, i64 0, i64 0), i64 37, i1 false) #3
  %671 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %670, i32 37) #3
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %670) #3
  %672 = getelementptr inbounds [1 x i8], [1 x i8]* %10, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 1, i8* nonnull %672) #3
  store i8 0, i8* %672, align 1
  %673 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %672, i32 1) #3
  call void @llvm.lifetime.end.p0i8(i64 1, i8* nonnull %672) #3
  br label %674

674:                                              ; preds = %544, %665
  %675 = phi i32 [ 3, %665 ], [ 0, %544 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %541)
  br label %676

676:                                              ; preds = %67, %70, %433, %527, %522, %674, %82, %77, %74, %63, %1
  %677 = phi i32 [ 0, %1 ], [ 2, %63 ], [ 0, %67 ], [ 2, %70 ], [ 0, %74 ], [ 2, %77 ], [ %434, %433 ], [ %675, %674 ], [ 0, %522 ], [ 0, %527 ], [ 2, %82 ]
  ret i32 %677
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare i64 @llvm.bswap.i64(i64) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !4, i64 0}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!3, !4, i64 4}
!8 = !{!9, !10, i64 12}
!9 = !{!"ethhdr", !5, i64 0, !5, i64 6, !10, i64 12}
!10 = !{!"short", !5, i64 0}
!11 = !{!12, !5, i64 9}
!12 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !10, i64 2, !10, i64 4, !10, i64 6, !5, i64 8, !5, i64 9, !10, i64 10, !4, i64 12, !4, i64 16}
!13 = !{!14, !10, i64 2}
!14 = !{!"udphdr", !10, i64 0, !10, i64 2, !10, i64 4, !10, i64 6}
!15 = !{!12, !4, i64 12}
!16 = !{!4, !4, i64 0}
!17 = !{!10, !10, i64 0}
!18 = !{!19, !4, i64 0}
!19 = !{!"dest_info", !4, i64 0, !4, i64 4, !5, i64 8, !10, i64 14}
!20 = !{!19, !10, i64 14}
!21 = !{!22, !22, i64 0}
!22 = !{!"long long", !5, i64 0}
!23 = !{!19, !4, i64 4}
!24 = !{!12, !4, i64 16}
!25 = !{!12, !10, i64 2}
!26 = !{!14, !10, i64 4}
!27 = !{!12, !10, i64 10}
!28 = !{!14, !10, i64 6}
!29 = !{!5, !5, i64 0}
