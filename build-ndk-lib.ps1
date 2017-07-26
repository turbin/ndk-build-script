
function build($target){
	$dest_dir="build/build_$target"
	$output="$dest_dir/output"
	
	# if exsit remove it 
	if(Test-Path $dest_dir)
	{	
		echo "rm $dest_dir"
		ri "$dest_dir" -recurse
	}
	
	cpi -Path "./Pad"  -Destination $dest_dir -Recurse -Force
	
	if((Test-Path $output) -ne 'True'){
		echo "mkdir $dest_dir/output"
		mkdir "$dest_dir/output"
	}

	$obj_dir='obj\local\armeabi'
	$dirs='sdtp','api','mpos'

	foreach($build in $dirs){
		ndk-build clean -C "$dest_dir/$build/jni"
		ndk-build -j3 DEVICE=$target -C "$dest_dir/$build/jni"
		Copy-Item -Path "$dest_dir/$build/$obj_dir/*.so" -Destination $output
		Copy-Item -Path "$dest_dir/$build/$obj_dir/*.a" -Destination $output
	}
}

function argument_checker([string]$in_arg){

}

function buildAll($in_devices){
	foreach($device in $in_devices){
		echo "in_device=$device";
		build($device);
	}
}

#default build all type
function main{
	param(
	[ValidateSet('N900_3G','N900_4G','IM81')]
	$in_args
	)
	
	$devices='N900_3G','N900_4G','IM81'
	if($in_args.Count -eq 0){
		echo "build in default"
		buildAll($in_devices=$devices);
	}
	else{
		buildAll($in_devices=$in_args);
	}
}

main($args);



