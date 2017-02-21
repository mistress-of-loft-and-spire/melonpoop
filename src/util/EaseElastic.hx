package util;

/**
 * Static class with useful easer functions that can be used by Tweens.
 */
class EaseElastic
{
	/** Elastic in. */
    public static function elasticIn (t:Float):Float
    {
        return -(ELASTIC_AMPLITUDE * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t - (ELASTIC_PERIOD / PI2 * Math.asin(1 / ELASTIC_AMPLITUDE))) * PI2 / ELASTIC_PERIOD));
    }

    /** Elastic out. */
    public static function elasticOut (t:Float):Float
    {
        return (ELASTIC_AMPLITUDE * Math.pow(2, -10 * t) * Math.sin((t - (ELASTIC_PERIOD / PI2 * Math.asin(1 / ELASTIC_AMPLITUDE))) * PI2 / ELASTIC_PERIOD) + 1);
    }

    /** Elastic in and out. */
    public static function elasticInOut (t:Float):Float
    {
        if (t < 0.5) {
            return -0.5 * (Math.pow(2, 10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * PI2 / ELASTIC_PERIOD));
        }
        return Math.pow(2, -10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * PI2 / ELASTIC_PERIOD) * 0.5 + 1;
    }

	// Easing constants.
	private static var PI(get,never):Float;
	private static var PI2(get,never):Float;
	private static var EL(get,never):Float;
	private static inline var B1:Float = 1 / 2.75;
	private static inline var B2:Float = 2 / 2.75;
	private static inline var B3:Float = 1.5 / 2.75;
	private static inline var B4:Float = 2.5 / 2.75;
	private static inline var B5:Float = 2.25 / 2.75;
	private static inline var B6:Float = 2.625 / 2.75;
	private static function get_PI(): Float  { return Math.PI; }
	private static function get_PI2(): Float { return Math.PI / 2; }
	private static function get_EL(): Float  { return 2 * PI / 0.45; }
	private static inline var ELASTIC_AMPLITUDE :Float = 1.5;
    private static inline var ELASTIC_PERIOD :Float = 0.1;
}
