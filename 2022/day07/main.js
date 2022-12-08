const fs = require('fs');
const u = require('updeep');

//let lines = fs.readFileSync('./example.txt',{encoding:'utf-8'}).split('\n')
let lines = fs.readFileSync('./silver.txt',{encoding:'utf-8'}).split('\n')

let inputFS = {}
let pwd = []

const mylog = (...m)=>{
	console.log(`\n=> ${pwd.join("/")}\t${m.join()}`);
}
for(let line of lines){
	switch(true){
		case /^\$ cd/.test(line):
			let newdir = line.match(/^\$ cd (.+)/)[1];
			mylog('change dir:', newdir)
			if(newdir==='..') pwd.pop()
			else if(newdir==='/') pwd = []
			else pwd.push(newdir)
			break;
		case /^\$ ls/.test(line):
			mylog('listing dir');
			break;
		case /^dir/.test(line):
			let name = line.match(/^dir (.+)/)[1];
			inputFS=u.updateIn(`${pwd.join('.')}.${name}`,{},inputFS)
			mylog('found dir', name)
			break;
		case /^\d+ .+/.test(line):
			let m = line.match(/(\d+) (.+)/);
			let size = m[1];
			let filename = m[2];
			//inputFS = u.updateIn(`${pwd.join('.')}.${filename}`,size,inputFS)
			inputFS = u.updateIn(`${pwd.join('.')}`,{[filename]:parseInt(size)},inputFS)
			mylog('found file')
			break;
		default:
			mylog('i have no idea', line)
			break;
	}

}
console.log(JSON.stringify(inputFS,null,2))

let sizes = {}
const dirSize = (cwd, dir) => {
	let size = 0;
	for(let item in dir){
		console.log(`iterate ${item} in [${cwd}]`);
		if(typeof dir[item] === "object"){
			console.log(cwd,item)
			let ds = dirSize([...cwd,item], dir[item])
			console.log(`dirSize of ${item}`,ds)
			sizes[`${cwd.join('-')}${item}`]=ds
			size+=ds
		}
		else{
			console.log(`adding size ${dir[item]} from ${item}`)
			size += dir[item]
		}
	}
	return size
}
let total = dirSize([], inputFS)
console.log(JSON.stringify(sizes, null,2))

console.log(total)

let summation = 0
for(let s in sizes)
	if(sizes[s]<=100000){
		console.log(`dir ${s} is under 100000 ${sizes[s]}`)
		summation+=sizes[s]
	} else {
	//	console.log(`dir ${s} is not`);
	}

console.log(summation)

let max=70000000
let need=30000000
let free=max-total
let toFree=need-free

console.log(max,need,free,toFree)
let smallest = [max,""]
for(let s in sizes){
	console.log(s,sizes[s],free+sizes[s],free+sizes[s]>need)
	if(sizes[s]+free>need && sizes[s]<smallest[0]) smallest=[sizes[s],s]
}

console.log(smallest)
