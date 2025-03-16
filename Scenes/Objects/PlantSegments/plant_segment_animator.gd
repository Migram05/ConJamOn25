extends Node2D
class_name PlantSegmentAnimator

@export var trunc : AnimatedSprite2D;
@export var glow : Sprite2D;

@export var perfectGlowTime := 0.5;
@export var damageAnimationTime := 0.3;
@export var perfectAnimationTime := 0.3;

@export var treeStatesNames = ["Idle", "Damage", "Perfect"];
enum treeStates {IDLE, DAMAGE, PERFECT};

var currentState := treeStates.IDLE;

var damageCounter := 0.0;
var perfectCounter := 0.0;
var glowCounter := perfectGlowTime;

func _ready():
	return
	glow.self_modulate.a = 0.0;

func startGlow():
	glow.self_modulate.a = 1.0;
	return
	
func endGlow():
	glow.self_modulate.a = 0.0;
	return

func onPerfect():
	perfectCounter = 0.0;
	glowCounter = 0.0;
	startGlow();
	currentState = treeStates.PERFECT;
	trunc.animation = treeStatesNames[treeStates.PERFECT];

func onDamage():
	damageCounter = 0.0;
	currentState = treeStates.DAMAGE;
	trunc.animation = treeStatesNames[treeStates.DAMAGE];

func setIdle():
	currentState = treeStates.IDLE;
	trunc.animation = treeStatesNames[treeStates.IDLE];

func process_damage(delta):
	damageCounter += delta;
	if (damageCounter >= damageAnimationTime):
		setIdle();

func process_perfect(delta):
	perfectCounter += delta;
	if (perfectCounter >= perfectAnimationTime):
		setIdle();

func _process(delta):
	match(currentState):
		treeStates.DAMAGE:
			process_damage(delta);
		treeStates.PERFECT:
			process_perfect(delta);
	if (glowCounter < perfectGlowTime):
		glowCounter += delta;
		if (glowCounter >= perfectAnimationTime):
			endGlow();
	
